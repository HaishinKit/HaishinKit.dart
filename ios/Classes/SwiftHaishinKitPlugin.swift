import Flutter
import UIKit
import HaishinKit

public class SwiftHaishinKitPlugin: NSObject, FlutterPlugin {
    public static let instance = SwiftHaishinKitPlugin()

    public static func register(with registrar: FlutterPluginRegistrar) {
        instance.registrar = registrar
        let channel = FlutterMethodChannel(name: "com.haishinkit", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    var registrar: FlutterPluginRegistrar?
    private var handlers: [Int: MethodCallHandler] = [:]

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
            if let connection = (call.arguments as? [String: Any?])?["connection"] as? NSNumber {
                if let handler = handlers[connection.intValue] as? RTMPConnectionHandler {
                    let stream = RTMPStreamHandler(plugin: self, handler: handler)
                    let memory = Int(bitPattern: ObjectIdentifier(stream))
                    handlers[memory] = stream
                    result(NSNumber(value: memory))
                }
            }
        case "getVersion":
            result(HaishinKitVersionNumber)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func onDispose(id: Int) {
        handlers.removeValue(forKey: id)
    }
}
