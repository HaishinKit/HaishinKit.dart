#if canImport(Flutter)
import Flutter
#endif
#if canImport(FlutterMacOS)
import FlutterMacOS
#endif

import HaishinKit
import RTMPHaishinKit
import SRTHaishinKit
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
                  let url = URL(string: arguments["url"] as? String ?? ""),
                  let mode = arguments["mode"] as? String
            else {
                result(nil)
                return
            }
            Task {
                do {
                    let session = try await SessionBuilderFactory.shared.make(url).setMode(mode == "playback" ? .playback : .publish).build()
                    if let session {
                        if mode == "publish" {
                            for handler in handlers {
                                if let handler = handler.value as? MediaMixerHandler {
                                    Task {
                                        handler.addOutput(await session.stream)
                                    }
                                }
                            }
                        }
                        let handler = SessionHandler(plugin: self, session: session)
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
                case .back: "back"
                case .front: "front"
                case .unspecified: "unspecified"
                default: "unspecified"
                }
                return [
                    "id": device.uniqueID,
                    "name": device.localizedName,
                    "position": position
                ]
            }
            result(videoList)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
