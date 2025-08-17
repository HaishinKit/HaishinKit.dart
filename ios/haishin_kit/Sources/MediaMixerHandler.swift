import Foundation
#if canImport(Flutter)
import Flutter
#endif
#if canImport(FlutterMacOS)
import FlutterMacOS
#endif
import HaishinKit
import AVFoundation
import VideoToolbox
#if canImport(UIKit)
import UIKit
#endif

final class MediaMixerHandler: NSObject {
    var texture: HKStreamFlutterTexture?

    #if os(macOS)
    private lazy var mixer = MediaMixer(multiTrackAudioMixingEnabled: false)
    #else
    private lazy var mixer = MediaMixer(multiCamSessionEnabled: false, multiTrackAudioMixingEnabled: false)
    #endif

    override init() {
        super.init()
        #if canImport(UIKit)
        NotificationCenter.default.addObserver(self, selector: #selector(on(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
        #endif
    }

    func addOutput(_ output: some MediaMixerOutput) {
        Task { await mixer.addOutput(output) }
    }

    func removeOutput(_ output: some MediaMixerOutput) {
        Task { await mixer.removeOutput(output) }
    }

    func stopRunning() {
        Task {
            await mixer.stopCapturing()
            await mixer.stopRunning()
        }
    }

    func dispose() async {
        await stopRunning()
        _ = try? await mixer.attachVideo(nil, track: 0)
        _ = try? await mixer.attachAudio(nil, track: 0)
    }

    #if canImport(UIKit)
    @objc
    private func on(_ notification: Notification) {
        guard let orientation = DeviceUtil.videoOrientation(by: UIApplication.shared.statusBarOrientation) else {
            return
        }
        Task { await mixer.setVideoOrientation(orientation) }
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
        case "RtmpStream#getHasAudio":
            Task {
                let isMuted = await !mixer.audioMixerSettings.isMuted
                result(isMuted)
            }

        case "RtmpStream#setHasAudio":
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
        case "RtmpStream#getHasVideo":
            Task {
                let hasVideo = await !mixer.videoMixerSettings.isMuted
                result(hasVideo)
            }
        case "RtmpStream#setHasVideo":
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
        case "RtmpStream#setFrameRate":
            guard
                let frameRate = arguments["value"] as? NSNumber else {
                result(nil)
                return
            }
            Task {
                await mixer.setFrameRate(frameRate.doubleValue)
                result(nil)
            }
        case "RtmpStream#setSessionPreset":
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
        case "RtmpStream#attachAudio":
            let source = arguments["source"] as? [String: Any?]
            Task {
                if source == nil {
                    try? await mixer.attachAudio(nil)
                } else {
                    try? await mixer.attachAudio(AVCaptureDevice.default(for: .audio))
                }
                result(nil)
            }
        case "RtmpStream#setScreenSettings":
            guard
                let settings = arguments["settings"] as? [String: Any?],
                let width = settings["width"] as? NSNumber,
                let height = settings["height"] as? NSNumber else {
                result(nil)
                return
            }
            Task { @ScreenActor in
                mixer.screen.size = CGSize(width: CGFloat(width.floatValue), height: CGFloat(height.floatValue))
                result(texture?.id)
            }
        case "RtmpStream#attachVideo":
            let source = arguments["source"] as? [String: Any?]
            if source == nil {
                Task {
                    try? await mixer.attachVideo(nil, track: 0)
                    result(nil)
                }
            } else {
                var devicePosition = AVCaptureDevice.Position.back
                if let position = source?["position"] as? String {
                    switch position {
                    case "front":
                        devicePosition = .front
                    case "back":
                        devicePosition = .back
                    default:
                        break
                    }
                }
                #if os(iOS)
                let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: devicePosition)
                #else
                let device = AVCaptureDevice.devices(for: .video).first
                #endif
                Task {
                    if let device = device {
                        try? await mixer.attachVideo(device, track: 0)
                    }
                    result(nil)
                }
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
