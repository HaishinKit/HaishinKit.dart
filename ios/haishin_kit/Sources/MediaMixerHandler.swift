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
    private lazy var mixer = MediaMixer(multiTrackAudioMixingEnabled: false)

    override init() {
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
            result(nil)
            return
        }
        switch call.method {
        case "MediaMixer#getHasAudio":
            Task {
                let isMuted = await !mixer.audioMixerSettings.isMuted
                result(isMuted)
            }
        case "MediaMixer#setHasAudio":
            guard let hasAudio = arguments["value"] as? Bool else {
                result(nil)
                return
            }
            Task {
                var audioMixerSettings = await mixer.audioMixerSettings
                audioMixerSettings.isMuted = !hasAudio
                await mixer.setAudioMixerSettings(audioMixerSettings)
                result(nil)
            }
        case "MediaMixer#getHasVideo":
            Task {
                let hasVideo = await !mixer.videoMixerSettings.isMuted
                result(hasVideo)
            }
        case "MediaMixer#setHasVideo":
            guard let hasVideo = arguments["value"] as? Bool else {
                result(nil)
                return
            }
            Task {
                var videoMixerSettings = await mixer.videoMixerSettings
                videoMixerSettings.isMuted = !hasVideo
                await mixer.setVideoMixerSettings(videoMixerSettings)
                result(nil)
            }
        case "MediaMixerm#setFrameRate":
            guard
                let frameRate = arguments["value"] as? NSNumber else {
                result(nil)
                return
            }
            Task {
                _ = try? await mixer.setFrameRate(frameRate.doubleValue)
                result(nil)
            }
        case "MediaMixer#setSessionPreset":
            guard let sessionPreset = arguments["value"] as? String else {
                result(nil)
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
        case "MediaMixer#setScreenSettings":
            guard
                let settings = arguments["settings"] as? [String: Any?],
                let width = settings["width"] as? NSNumber,
                let height = settings["height"] as? NSNumber
            else {
                result(nil)
                return
            }
            Task { @ScreenActor in
                mixer.screen.size = CGSize(width: CGFloat(width.floatValue), height: CGFloat(height.floatValue))
                result(nil)
            }
        case "MediaMixer#attachVideo":
            guard let track = arguments["track"] as? UInt8 else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "track is nil", details: nil))
                return
            }
            let source = arguments["source"] as? [String: Any?]
            guard let id = source?["id"] as? String else {
                Task {
                    try? await mixer.attachVideo(nil, track: track)
                    result(nil)
                }
                return
            }
            Task {
                if let device = AVCaptureDevice(uniqueID: id) {
                    try? await mixer.attachVideo(device, track: track)
                }
                result(nil)
            }
        case "MediaMixer#startRunning":
            Task {
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
