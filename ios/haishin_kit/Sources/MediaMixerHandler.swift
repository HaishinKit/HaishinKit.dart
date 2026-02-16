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
#if canImport(UIKit)
import UIKit
#endif

final class MediaMixerHandler: NSObject {
    enum ErrorCode: String {
        case invalidArgument = "INVALID_ARGUMENT"
        case deviceNotFound = "DEVICE_NOT_FOUND"
        case failedToAttach = "FAILED_TO_ATTACH"

        func makeFlutterError(_ message: String? = nil, details: Any? = nil) -> FlutterError {
            return FlutterError(code: self.rawValue, message: message, details: details)
        }
    }
    internal private(set) lazy var mixer = MediaMixer(
        captureSessionMode: options.captureSessionMode,
        multiTrackAudioMixingEnabled: options.multiTrackAudioMixingEnabled
    )
    private let options: MediaMixerOptions
    private lazy var decoder = JSONDecoder()

    init(options: MediaMixerOptions) {
        self.options = options
        super.init()
        #if canImport(UIKit)
        NotificationCenter.default.addObserver(self, selector: #selector(on(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
        #endif
    }

    func addOutput(_ output: some MediaMixerOutput) {
        Task {
            await mixer.addOutput(output)
        }
    }

    func removeOutput(_ output: some MediaMixerOutput) {
        Task {
            await mixer.removeOutput(output)
        }
    }

    #if canImport(UIKit)
    @objc
    private func on(_ notification: Notification) {
        guard let orientation = DeviceUtil.videoOrientation(by: UIApplication.shared.statusBarOrientation) else {
            return
        }
        Task {
            await mixer.setVideoOrientation(orientation)
        }
    }
    #endif
}

extension MediaMixerHandler: MethodCallHandler {
    // MARK: MethodCallHandler
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard
            let arguments = call.arguments as? [String: Any?] else {
            result(ErrorCode.invalidArgument.makeFlutterError())
            return
        }
        switch call.method {
        case "MediaMixer#setAudioMixerSettings":
            guard
                let value = ((arguments["value"] as? String) ?? "").data(using: .utf8),
                let pluginAudioMixerSettings = try? decoder.decode(PluginAudioMixerSettings.self, from: value)
            else {
                result(ErrorCode.invalidArgument.makeFlutterError())
                return
            }
            Task {
                var audioMixerSettings = await mixer.audioMixerSettings
                // audioMixerSettings.channels = pluginAudioMixerSettings.channels
                audioMixerSettings.mainTrack = pluginAudioMixerSettings.mainTrack
                audioMixerSettings.isMuted = pluginAudioMixerSettings.isMuted
                await mixer.setAudioMixerSettings(audioMixerSettings)
                result(nil)
            }
        case "MediaMixer#setVideoMixerSettings":
            guard
                let value = ((arguments["value"] as? String) ?? "").data(using: .utf8),
                let videoMixerSettings = try? decoder.decode(VideoMixerSettings.self, from: value)
            else {
                result(ErrorCode.invalidArgument.makeFlutterError())
                return
            }
            Task {
                await mixer.setVideoMixerSettings(videoMixerSettings)
                result(nil)
            }
        case "MediaMixer#setFrameRate":
            guard
                let frameRate = arguments["value"] as? NSNumber else {
                result(ErrorCode.invalidArgument.makeFlutterError())
                return
            }
            Task {
                _ = try? await mixer.setFrameRate(frameRate.doubleValue)
                result(nil)
            }
        case "MediaMixer#setSessionPreset":
            guard let sessionPreset = arguments["value"] as? String else {
                result(ErrorCode.invalidArgument.makeFlutterError())
                return
            }
            let preset: AVCaptureSession.Preset = switch sessionPreset {
            case "high": .high
            case "medium": .medium
            case "low": .low
            case "hd1280x720": .hd1280x720
            case "hd1920x1080": .hd1920x1080
            case "hd4K3840x2160": .hd4K3840x2160
            case "vga640x480": .vga640x480
            case "iFrame960x540": .iFrame960x540
            case "iFrame1280x720": .iFrame1280x720
            case "cif352x288": .cif352x288
            default: .hd1280x720
            }
            Task {
                await mixer.setSessionPreset(preset)
                result(nil)
            }
        case "MediaMixer#attachAudio":
            let source = arguments["source"] as? [String: Any?]
            Task {
                if source == nil {
                    try? await mixer.attachAudio(nil)
                } else {
                    try? await mixer.attachAudio(AVCaptureDevice.default(for: .audio))
                }
                result(nil)
            }
        case "MediaMixer#attachVideo":
            guard let track = arguments["track"] as? UInt8 else {
                result(ErrorCode.invalidArgument.makeFlutterError())
                return
            }
            guard let value = arguments["value"] as? String else {
                Task {
                    try? await mixer.attachVideo(nil, track: track)
                    result(nil)
                }
                return
            }
            guard
                let data = value.data(using: .utf8),
                let videoSource = try? JSONDecoder().decode(VideoSource.self, from: data)
            else {
                result(ErrorCode.invalidArgument.makeFlutterError())
                return
            }
            Task {
                if let device = AVCaptureDevice(uniqueID: videoSource.id) {
                    do {
                        try await mixer.attachVideo(device, track: track)
                        result(nil)
                    } catch {
                        result(ErrorCode.failedToAttach.makeFlutterError())
                    }
                } else {
                    result(ErrorCode.deviceNotFound.makeFlutterError())
                }
            }
        case "MediaMixer#startRunning":
            Task {
                var videoMixerSettings = await mixer.videoMixerSettings
                videoMixerSettings.mode = .offscreen
                await mixer.setVideoMixerSettings(videoMixerSettings)
                await mixer.startRunning()
                result(nil)
            }
        case "MediaMixer#stopRunning":
            Task {
                await mixer.stopRunning()
                result(nil)
            }
        case "MediaMixer#dispose":
            Task {
                await mixer.stopRunning()
                result(nil)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
