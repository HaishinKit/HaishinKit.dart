#if canImport(Flutter)
import Flutter
#endif
#if canImport(FlutterMacOS)
import FlutterMacOS
#endif

import HaishinKit
import RTMPHaishinKit
import SRTHaishinKit
import RTCHaishinKit
import AVFoundation

public final class HaishinKitPlugin: NSObject {
    private static let instance = HaishinKitPlugin()

    public static func register(with registrar: FlutterPluginRegistrar) {
        instance.registrar = registrar
        let channel = FlutterMethodChannel(name: "com.haishinkit", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: channel)
        #if os(iOS)
        MainActor.assumeIsolated {
            registrar.register(HdrViewFactory(plugin: instance), withId: "com.haishinkit.hdr")
        }
        #endif
    }

    private(set) var handlers: [Int: MethodCallHandler] = [:]
    private(set) var registrar: FlutterPluginRegistrar?

    override init() {
        super.init()
        Task {
            await StreamSessionBuilderFactory.shared.register(RTMPSessionFactory())
            await StreamSessionBuilderFactory.shared.register(SRTSessionFactory())
            await StreamSessionBuilderFactory.shared.register(HTTPSessionFactory())
        }
    }

    func onDispose(id: Int) {
        handlers.removeValue(forKey: id)
    }
}

extension HaishinKitPlugin: FlutterPlugin {
    // MARK: FlutterPlugin
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let memory = (call.arguments as? [String: Any?])?["memory"] as? NSNumber {
            if let handler = handlers[memory.intValue] {
                handler.handle(call, result: result)
            } else {
                result(FlutterMethodNotImplemented)
            }
            return
        }
        switch call.method {
        case "newSession":
            guard let arguments = call.arguments as? [String: Any?],
                  let url = URL(string: arguments["url"] as? String ?? "")
            else {
                result(nil)
                return
            }
            Task {
                let mode: StreamSessionMode = arguments["mode"] as? String == "publish" ? .publish : .playback
                do {
                    guard let range = PluginDynamicRangeMode(rawValue: arguments["dynamicRangeMode"] as? String ?? "sdr") else {
                        throw NSError(domain: "HaishinKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown dynamic range"])
                    }
                    try range.validate()
                    if range == .hlg && !["rtmp", "rtmps"].contains(url.scheme?.lowercased() ?? "") {
                        throw NSError(domain: "HaishinKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "HLG sessions require RTMP"])
                    }
                    let session = try await StreamSessionBuilderFactory.shared.make(url).setMode(mode).build()
                    if let session {
                        if mode == .publish {
                            for handler in handlers {
                                if let handler = handler.value as? MediaMixerHandler, handler.dynamicRangeMode == range {
                                    Task {
                                        handler.addOutput(await session.stream)
                                    }
                                }
                            }
                        }
                        let handler = StreamSessionHandler(plugin: self, session: session, dynamicRangeMode: range,
                                                           protocolScheme: url.scheme?.lowercased() ?? "", mode: mode)
                        let memory = Int(bitPattern: ObjectIdentifier(handler))
                        handlers[memory] = handler
                        result(NSNumber(value: memory))
                    } else {
                        result(nil)
                    }
                } catch {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: error.localizedDescription, details: nil))
                }
            }
        case "newScreen":
            guard
                let arguments = call.arguments as? [String: Any?],
                let mixer = arguments["mixer"] as? Int,
                let handler = handlers[mixer] as? MediaMixerHandler else {
                return
            }
            Task { @ScreenActor in
                let handler = ScreenHandler(plugin: self, screen: await handler.mixer.screen)
                let memory = Int(bitPattern: ObjectIdentifier(handler))
                handlers[memory] = handler
                result(NSNumber(value: memory))
            }
        case "newMediaMixer":
            do {
                let options: MediaMixerOptions = try PluginUtil.decode(call: call)
                let handler = MediaMixerHandler(options: options)
                Task { @MainActor in
                    do {
                        try await handler.configureDynamicRange()
                        let memory = Int(bitPattern: ObjectIdentifier(handler))
                        handlers[memory] = handler
                        result(NSNumber(value: memory))
                    } catch {
                        result(FlutterError(code: "INVALID_ARGUMENT", message: error.localizedDescription, details: nil))
                    }
                }
            } catch {
                result(FlutterError(code: "INVALID_ARGUMENT", message: error.localizedDescription, details: nil))
            }
        case "getSupportedVideoCodecs":
            let arguments = call.arguments as? [String: Any?] ?? [:]
            guard let range = PluginDynamicRangeMode(rawValue: arguments["dynamicRangeMode"] as? String ?? "sdr") else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Unknown dynamic range", details: nil))
                return
            }
            Task { @MainActor in
                do {
                    let codecs = try await Task.detached { try NativeVideoCodecs.supported(range: range) }.value
                    result(codecs)
                } catch {
                    result(FlutterError(code: "CODEC_QUERY_FAILED", message: error.localizedDescription, details: nil))
                }
            }
        case "getPlatformVersion":
            result(kHaishinKitIdentifier)
        case "getVideoSources":
            #if os(macOS)
            let deviceTypes: [AVCaptureDevice.DeviceType] = [
                .builtInWideAngleCamera,
                .externalUnknown
            ]
            #else
            let deviceTypes: [AVCaptureDevice.DeviceType] = [
                .builtInWideAngleCamera,
                .builtInUltraWideCamera,
                .builtInTelephotoCamera,
                .builtInDualCamera,
                .builtInDualWideCamera,
                .builtInTripleCamera
            ]
            #endif
            let discoverySession = AVCaptureDevice.DiscoverySession(
                deviceTypes: deviceTypes,
                mediaType: .video,
                position: .unspecified)
            let videoList = discoverySession.devices.map {
                device in
                let position = switch device.position {
                case .back: VideoSource.CameraPosition.back
                case .front: VideoSource.CameraPosition.front
                case .unspecified: VideoSource.CameraPosition.unspecified
                default: VideoSource.CameraPosition.unspecified
                }
                return VideoSource(id: device.uniqueID, name: device.localizedName, position: position)
            }
            do {
                result(String(data: try JSONEncoder().encode(videoList), encoding: .utf8))
            } catch {
                result(FlutterMethodNotImplemented)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
