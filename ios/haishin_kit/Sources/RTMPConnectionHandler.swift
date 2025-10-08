import Foundation
#if canImport(Flutter)
import Flutter
#endif
#if canImport(FlutterMacOS)
import FlutterMacOS
#endif
import HaishinKit
import RTMPHaishinKit

final class RTMPConnectionHandler: NSObject, MethodCallHandler {
    var instance: RTMPConnection?
    private let plugin: HaishinKitPlugin
    private var channel: FlutterEventChannel?
    private var eventSink: FlutterEventSink?
    private var subscription: Task<(), Error>? {
        didSet {
            oldValue?.cancel()
        }
    }

    init(plugin: HaishinKitPlugin) {
        self.plugin = plugin
        super.init()
        let id = Int(bitPattern: ObjectIdentifier(self))
        if let messanger = plugin.registrar?.messenger() {
            self.channel = FlutterEventChannel(name: "com.haishinkit.eventchannel/\(id)", binaryMessenger: messanger)
        } else {
            self.channel = nil
        }
        instance = RTMPConnection()
        channel?.setStreamHandler(self)
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "RtmpConnection#connect":
            guard
                let arguments = call.arguments as? [String: Any?],
                let command = arguments["command"] as? String else {
                return
            }
            if let instance {
                subscription = Task {
                    for await status in await instance.status {
                        DispatchQueue.main.async {
                            print("got event, \(status)")
                            self.eventSink?(status.makeEvent())
                        }
                    }
                }
            }
            Task {
                do {
                    _ = try await instance?.connect(command)
                } catch {
                    result(FlutterError(code: "RTMP_CONNECT_FAILED", message: String(describing: error), details: nil))
                    return
                }
                result(nil)
            }
        case "RtmpConnection#close":
            subscription = nil
            Task {
                try? await instance?.close()
                result(nil)
            }
        case "RtmpConnection#dispose":
            instance = nil
            plugin.onDispose(id: Int(bitPattern: ObjectIdentifier(self)))
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

extension RTMPConnectionHandler: FlutterStreamHandler {
    // MARK: FlutterStreamHandler
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}
