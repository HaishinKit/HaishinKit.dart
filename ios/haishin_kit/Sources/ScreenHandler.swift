import Foundation
#if canImport(Flutter)
import Flutter
#endif
#if canImport(FlutterMacOS)
import FlutterMacOS
#endif
import HaishinKit

final class ScreenHandler: NSObject {
    enum ErrorCode: String {
        case invalidArgument = "INVALID_ARGUMENT"

        func makeFlutterError(_ message: String? = nil, details: Any? = nil) -> FlutterError {
            return FlutterError(code: self.rawValue, message: message, details: details)
        }
    }
    private var screen: Screen?
    private lazy var decoder = JSONDecoder()
    private var plugin: HaishinKitPlugin? {
        didSet {
            oldValue?.onDispose(id: Int(bitPattern: ObjectIdentifier(self)))
        }
    }

    @ScreenActor
    private lazy var screenObjectFactory = ScreenObjectFactory()

    init(plugin: HaishinKitPlugin, screen: Screen?) {
        self.plugin = plugin
        self.screen = screen
        super.init()
    }
}

extension ScreenHandler: MethodCallHandler {
    // MARK: MethodCallHandler
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard
            let arguments = call.arguments as? [String: Any?] else {
            result(nil)
            return
        }
        switch call.method {
        case "Screen#addChild":
            guard
                let value = arguments["value"] as? String,
                let data = value.data(using: .utf8) else {
                result(ErrorCode.invalidArgument.makeFlutterError())
                return
            }
            Task { @ScreenActor in
                do {
                    let snapshot = try decoder.decode(ScreenObjectSnapshot.self, from: data)
                    let screenObject = screenObjectFactory.make(snapshot)
                    print(screenObject)
                    try screen?.addChild(screenObject)
                    result(nil)
                } catch {
                    result(ErrorCode.invalidArgument.makeFlutterError())
                }
            }
        case "Screen#removeChild":
            guard let value = arguments["value"] as? String else {
                result(ErrorCode.invalidArgument.makeFlutterError())
                return
            }
            Task { @ScreenActor in
                if let screenObject = screen?.findById(value) {
                    screenObject.parent?.removeChild(screenObject)
                }
                result(nil)
            }
        case "Screen#layout":
            guard
                let value = arguments["value"] as? String,
                let data = value.data(using: .utf8) else {
                result(ErrorCode.invalidArgument.makeFlutterError())
                return
            }
            Task { @ScreenActor in
                do {
                    try getScreenObjectBySnapshot(data)
                    result(nil)
                } catch {
                    result(ErrorCode.invalidArgument.makeFlutterError())
                }
            }
        case "Screen#dispose":
            screen = nil
            plugin = nil
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    @ScreenActor
    private func getScreenObjectBySnapshot(_ snapshot: Data) throws -> ScreenObject? {
        let snapshot = try decoder.decode(ScreenObjectSnapshot.self, from: snapshot)
        guard var screenObject = screen?.findById(snapshot.id) else {
            return screenObjectFactory.make(snapshot)
        }
        screenObject.isVisible = snapshot.isVisible
        screenObject.layoutMargin = .init(
            top: CGFloat(snapshot.layoutMargin.top),
            left: CGFloat(snapshot.layoutMargin.left),
            bottom: CGFloat(snapshot.layoutMargin.bottom),
            right: CGFloat(snapshot.layoutMargin.right)
        )
        screenObject.horizontalAlignment = .init(rawValue: snapshot.horizontalAlignment) ?? .left
        screenObject.verticalAlignment = .init(rawValue: snapshot.verticalAlignment) ?? .top
        screenObject.elements = snapshot.elements
        return screenObject
    }
}
