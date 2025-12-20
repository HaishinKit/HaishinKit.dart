#if canImport(Flutter)
import Flutter
#endif
#if canImport(FlutterMacOS)
import FlutterMacOS
#endif
import HaishinKit
import AVFoundation

public final class HaishinKitPlugin: NSObject {
    private static let instance = HaishinKitPlugin()

    public static func register(with registrar: FlutterPluginRegistrar) {
        instance.registrar = registrar
        let channel = FlutterMethodChannel(name: "com.haishinkit", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    private var handlers: [Int: MethodCallHandler] = [:]
    private(set) var mixer: MediaMixerHandler? {
        didSet {
            oldValue?.stopRunning()
        }
    }
    private(set) var registrar: FlutterPluginRegistrar?

    func onDispose(id: Int) {
        handlers.removeValue(forKey: id)
        var hasStreamHandler = false
        for handler in handlers where handler.value is RTMPStreamHandler {
            hasStreamHandler = true
        }
        if !hasStreamHandler {
            mixer?.stopRunning()
            mixer = nil
        }
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
        case "newRtmpConnection":
            let handler = RTMPConnectionHandler(plugin: self)
            let memory = Int(bitPattern: ObjectIdentifier(handler))
            handlers[memory] = handler
            result(NSNumber(value: memory))
        case "newRtmpStream":
            guard
                let connection = (call.arguments as? [String: Any?])?["connection"] as? NSNumber,
                let handler = handlers[connection.intValue] as? RTMPConnectionHandler else {
                result(nil)
                return
            }
            if mixer == nil {
                mixer = MediaMixerHandler()
            }
            let stream = RTMPStreamHandler(plugin: self, handler: handler)
            let memory = Int(bitPattern: ObjectIdentifier(stream))
            handlers[memory] = stream
            result(NSNumber(value: memory))
        case "getPlatformVersion":
            result(kHaishinKitIdentifier)
        case "getVideoSources":
            #if os(macOS)
            let deviceTypes: [AVCaptureDevice.DeviceType] = [
                    .builtInWideAngleCamera,
                    .externalUnknown,
                ]
            #else
            let deviceTypes: [AVCaptureDevice.DeviceType] = [
                    .builtInWideAngleCamera,
                    .externalUnknown,
                    .builtInUltraWideCamera,
                    .builtInTelephotoCamera,
                    .builtInDualCamera,
                    .builtInDualWideCamera,
                    .builtInTripleCamera,
                ]
            #endif
            let discoverySession = AVCaptureDevice.DiscoverySession(
                deviceTypes: deviceTypes,
                mediaType: .video,
                position: .unspecified)
            let videoList = discoverySession.devices.map { device in
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
