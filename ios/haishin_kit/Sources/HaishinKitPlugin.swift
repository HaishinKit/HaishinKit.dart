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
    }

    private(set) var handlers: [Int: MethodCallHandler] = [:]
    private(set) var registrar: FlutterPluginRegistrar?

    override init() {
        super.init()
        Task {
            await SessionBuilderFactory.shared.register(RTMPSessionFactory())
            await SessionBuilderFactory.shared.register(SRTSessionFactory())
            await SessionBuilderFactory.shared.register(HTTPSessionFactory())
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
                let mode: SessionMode = arguments["mode"] as? String == "publish" ? .publish : .playback
                do {
                    let session = try await SessionBuilderFactory.shared.make(url).setMode(mode).build()
                    if let session {
                        if mode == .publish {
                            for handler in handlers {
                                if let handler = handler.value as? MediaMixerHandler {
                                    Task {
                                        handler.addOutput(await session.stream)
                                    }
                                }
                            }
                        }
                        let handler = StreamSessionHandler(plugin: self, session: session)
                        let memory = Int(bitPattern: ObjectIdentifier(handler))
                        handlers[memory] = handler
                        result(NSNumber(value: memory))
                    } else {
                        result(nil)
                    }
                } catch {
                    result(nil)
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
            let handler = MediaMixerHandler()
            let memory = Int(bitPattern: ObjectIdentifier(handler))
            handlers[memory] = handler
            result(NSNumber(value: memory))
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
