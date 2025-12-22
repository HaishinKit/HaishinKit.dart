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

final class SessionHandler: NSObject {
    private let plugin: HaishinKitPlugin
    private var session: Session?
    private var texture: StreamFlutterTexture?

    init(plugin: HaishinKitPlugin, session: Session) {
        self.plugin = plugin
        self.session = session
        super.init()
    }
}

extension SessionHandler: MethodCallHandler {
    // MARK: MethodCallHandler
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard
            let arguments = call.arguments as? [String: Any?] else {
            result(nil)
            return
        }
        switch call.method {
        case "Session#setAudioSettings":
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
        case "Session#setVideoSettings":
            guard
                let settings = arguments["settings"] as? [String: Any?] else {
                result(nil)
                return
            }
            Task {
                var videoSettings = await session?.stream.videoSettings ?? .default
                if let bitrate = settings["bitrate"] as? NSNumber {
                    videoSettings.bitRate = bitrate.intValue
                }
                if let width = settings["width"] as? NSNumber, let height = settings["height"] as? NSNumber {
                    videoSettings.videoSize = CGSize(width: .init(width.intValue), height: .init(height.intValue))
                }
                if let frameInterval = settings["frameInterval"] as? NSNumber {
                    videoSettings.maxKeyFrameIntervalDuration = frameInterval.int32Value
                }
                if let profileLevel = settings["profileLevel"] as? String {
                    videoSettings.profileLevel = ProfileLevel(rawValue: profileLevel)?.kVTProfileLevel ?? ProfileLevel.H264_Baseline_AutoLevel.kVTProfileLevel
                }
                _ = try? await session?.stream.setVideoSettings(videoSettings)
                result(nil)
            }
        case "Session#registerTexture":
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
        case "Session#unregisterTexture":
            guard
                let registry = plugin.registrar?.textures() else {
                result(nil)
                return
            }
            if let textureId = arguments["id"] as? Int64 {
                registry.unregisterTexture(textureId)
            }
            result(nil)
        case "Session#updateTextureSize":
            guard let _ = plugin.registrar?.textures() else {
                result(nil)
                return
            }
            if let texture {
                if let width = arguments["width"] as? NSNumber,
                   let height = arguments["height"] as? NSNumber {
                    texture.bounds = CGSize(width: width.doubleValue, height: height.doubleValue)
                }
                result(texture.id)
            } else {
                result(nil)
            }
        case "Session#connect":
            Task {
                try? await session?.connect {
                }
                result(true)
            }
        case "Session#close":
            Task {
                _ = try? await session?.close()
                result(nil)
            }
        case "Session#dispose":
            texture = nil
            session = nil
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
