import Foundation
#if canImport(Flutter)
import Flutter
#endif
#if canImport(FlutterMacOS)
import FlutterMacOS
#endif
import HaishinKit
import RTMPHaishinKit
import AVFoundation
import VideoToolbox

final class StreamSessionHandler: NSObject {
    let dynamicRangeMode: PluginDynamicRangeMode
    enum ErrorCode: String {
        case connectFailed = "CONNECT_FAILED"
        case invalidArgument = "INVALID_ARGUMENT"

        func makeFlutterError(_ message: String? = nil, details: Any? = nil) -> FlutterError {
            return FlutterError(code: self.rawValue, message: message, details: details)
        }
    }

    private let plugin: HaishinKitPlugin
    private var session: StreamSession?
    private let protocolScheme: String
    private let mode: StreamSessionMode
    private var pendingConnectionOperations = 0
    private var isDisposed = false
    #if os(iOS)
    private var hdrOutputs: [ObjectIdentifier: MTHKView] = [:]
    #endif
    private lazy var decoder = JSONDecoder()
    private var texture: StreamFlutterTexture?
    private var channel: FlutterEventChannel?
    private var eventSink: FlutterEventSink?
    private var subscription: Task<(), Error>? {
        didSet {
            oldValue?.cancel()
        }
    }

    init(plugin: HaishinKitPlugin, session: StreamSession, dynamicRangeMode: PluginDynamicRangeMode = .sdr,
         protocolScheme: String = "rtmp", mode: StreamSessionMode = .publish) {
        self.plugin = plugin
        self.session = session
        self.dynamicRangeMode = dynamicRangeMode
        self.protocolScheme = protocolScheme
        self.mode = mode
        super.init()
        let id = Int(bitPattern: ObjectIdentifier(self))
        if let messanger = plugin.registrar?.messenger() {
            self.channel = FlutterEventChannel(name: "com.haishinkit.eventchannel/\(id)", binaryMessenger: messanger)
        } else {
            self.channel = nil
        }
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            self.channel?.setStreamHandler(self)
        }
        subscription = Task { [weak self] in
            for await status in await session.readyState {
                DispatchQueue.main.async { [eventSink = self?.eventSink] in
                    eventSink?("\(status)")
                }
            }
        }
    }

    private func videoProfile(_ settings: [String: Any?], preserving previous: String) throws -> String {
        guard settings["codec"] as? String != nil || settings["profileLevel"] as? String != nil else {
            return previous
        }
        let codec = settings["codec"] as? String ?? "h264"
        let allowed = ["rtmp", "rtmps", "srt"].contains(protocolScheme) ? ["h264", "hevc"] : ["h264"]
        guard allowed.contains(codec), dynamicRangeMode == .sdr || codec == "hevc" else {
            throw NSError(domain: "HaishinKit", code: -1, userInfo: [NSLocalizedDescriptionKey:
                "Unsupported video codec or range for this Apple session: \(codec)"])
        }
        if codec == "hevc" {
            return dynamicRangeMode == .hlg ? kVTProfileLevel_HEVC_Main10_AutoLevel as String : kVTProfileLevel_HEVC_Main_AutoLevel as String
        }
        if settings["profileLevel"] as? String == nil && previous.hasPrefix("H264") {
            return previous
        }
        guard let profile = ProfileLevel(rawValue: settings["profileLevel"] as? String ?? "H264_Baseline_3_1") else {
            throw NSError(domain: "HaishinKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unsupported H.264 profile"])
        }
        return profile.kVTProfileLevel
    }

    #if os(iOS)
    @MainActor
    func addHdrOutput(_ view: MTHKView) {
        guard !isDisposed, dynamicRangeMode == .hlg, let session else { return }
        let id = ObjectIdentifier(view)
        hdrOutputs[id] = view
        Task { @MainActor [weak self] in
            guard let self, !isDisposed, hdrOutputs[id] === view else { return }
            let stream = await session.stream
            guard !isDisposed, hdrOutputs[id] === view else { return }
            await stream.addOutput(view)
            if isDisposed || hdrOutputs[id] !== view { await stream.removeOutput(view) }
        }
    }

    @MainActor
    func removeHdrOutput(_ view: MTHKView) {
        guard hdrOutputs.removeValue(forKey: ObjectIdentifier(view)) != nil, let session else { return }
        Task { await session.stream.removeOutput(view) }
    }
    #endif
}

extension StreamSessionHandler: MethodCallHandler {
    // MARK: MethodCallHandler
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard
            let arguments = call.arguments as? [String: Any?] else {
            result(nil)
            return
        }
        switch call.method {
        case "StreamSession#setAudioSettings":
            guard
                let settings = arguments["settings"] as? [String: Any?] else {
                result(nil)
                return
            }
            if let bitrate = settings["bitrate"] as? NSNumber {
                Task {
                    var audioSettings = await session?.stream.audioSettings ?? .default
                    audioSettings.bitRate = bitrate.intValue
                    _ = try? await session?.stream.setAudioSettings(audioSettings)
                    result(nil)
                }
                return
            }
            result(nil)
        case "StreamSession#setVideoSettings":
            guard
                let settings = arguments["settings"] as? [String: Any?] else {
                result(nil)
                return
            }
            Task { @MainActor in
                guard !isDisposed, let session else {
                    result(ErrorCode.invalidArgument.makeFlutterError("The session is disposed"))
                    return
                }
                let previous = await session.stream.videoSettings
                var videoSettings = previous
                if let bitrate = settings["bitrate"] as? NSNumber {
                    videoSettings.bitRate = bitrate.intValue
                }
                if let width = settings["width"] as? NSNumber, let height = settings["height"] as? NSNumber {
                    videoSettings.videoSize = CGSize(width: .init(width.intValue), height: .init(height.intValue))
                }
                if let frameInterval = settings["frameInterval"] as? NSNumber {
                    videoSettings.maxKeyFrameIntervalDuration = frameInterval.int32Value
                }
                do {
                    videoSettings.profileLevel = try videoProfile(settings, preserving: previous.profileLevel)
                    let connected = await session.connected
                    if pendingConnectionOperations > 0 || connected {
                        guard videoSettings.videoSize == previous.videoSize,
                              videoSettings.profileLevel == previous.profileLevel,
                              videoSettings.maxKeyFrameIntervalDuration == previous.maxKeyFrameIntervalDuration else {
                            throw NSError(domain: "HaishinKit", code: -1, userInfo: [NSLocalizedDescriptionKey:
                                "Close the session before changing video dimensions, codec or profile"])
                        }
                    }
                    try await session.stream.setVideoSettings(videoSettings)
                    result(nil)
                } catch {
                    result(ErrorCode.invalidArgument.makeFlutterError(error.localizedDescription))
                }
            }
        case "StreamSession#registerTexture":
            guard dynamicRangeMode == .sdr else {
                result(ErrorCode.invalidArgument.makeFlutterError("HLG previews require StreamSessionView"))
                return
            }
            guard
                let registry = plugin.registrar?.textures() else {
                result(nil)
                return
            }
            if let texture {
                result(texture.id)
            } else {
                let texture = StreamFlutterTexture(registry: registry)
                self.texture = texture
                Task {
                    await session?.stream.addOutput(texture)
                    result(texture.id)
                }
            }
        case "StreamSession#unregisterTexture":
            guard
                let registry = plugin.registrar?.textures() else {
                result(nil)
                return
            }
            if let textureId = arguments["id"] as? Int64 {
                registry.unregisterTexture(textureId)
            }
            result(nil)
        case "StreamSession#updateTexture":
            guard let _ = plugin.registrar?.textures(), let texture else {
                result(nil)
                return
            }
            guard
                let value = ((arguments["value"] as? String) ?? "").data(using: .utf8),
                let snapshot = try? decoder.decode(StreamFlutterTextureSnapshot.self, from: value)
            else {
                result(ErrorCode.invalidArgument.makeFlutterError())
                return
            }
            texture.bounds = CGSize(width: snapshot.width, height: snapshot.height)
            texture.videoGravity = snapshot.videoGravity.rawValue
            result(texture.id)
        case "StreamSession#connect":
            pendingConnectionOperations += 1
            Task { @MainActor in
                defer { pendingConnectionOperations -= 1 }
                guard !isDisposed, let session else {
                    result(ErrorCode.invalidArgument.makeFlutterError("The session is disposed"))
                    return
                }
                do {
                    if dynamicRangeMode == .hlg && mode == .publish {
                        let profile = await session.stream.videoSettings.profileLevel
                        guard profile == kVTProfileLevel_HEVC_Main10_AutoLevel as String else {
                            throw NSError(domain: "HaishinKit", code: -1, userInfo: [NSLocalizedDescriptionKey:
                                "Select HEVC video settings before publishing HLG"])
                        }
                    }
                    try await session.connect {}
                    result(nil)
                } catch {
                    result(ErrorCode.connectFailed.makeFlutterError(error.localizedDescription))
                }
            }
        case "StreamSession#close":
            pendingConnectionOperations += 1
            Task { @MainActor in
                defer { pendingConnectionOperations -= 1 }
                _ = try? await session?.close()
                result(nil)
            }
        case "StreamSession#dispose":
            Task { @MainActor in
                isDisposed = true
                subscription = nil
                texture = nil
                #if os(iOS)
                let activeSession = session
                #endif
                session = nil
                #if os(iOS)
                let outputs = Array(hdrOutputs.values)
                hdrOutputs.removeAll()
                if let stream = await activeSession?.stream {
                    for output in outputs { await stream.removeOutput(output) }
                }
                #endif
                result(nil)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

extension StreamSessionHandler: FlutterStreamHandler {
    // MARK: FlutterStreamHandler
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}
