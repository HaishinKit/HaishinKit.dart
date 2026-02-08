import Foundation
#if canImport(Flutter)
import Flutter
#endif
#if canImport(FlutterMacOS)
import FlutterMacOS
#endif
import HaishinKit

@ScreenActor
final class ScreenHandler: NSObject {
    private var screen: Screen?
    private lazy var decoder = JSONDecoder()
    private lazy var screenObjectFactory = ScreenObjectFactory()

    init(screen: Screen?) {
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
                return
            }
            do {
                let snapshot = try decoder.decode(ScreenObjectSnapshot.self, from: data)
                let screenObject = screenObjectFactory.make(snapshot)
                try screen?.addChild(screenObject)
                result(nil)
            } catch {
                result(nil)
            }
        case "Screen#removeChild":
            result(FlutterMethodNotImplemented)
        case "Screen#layout":
            guard
                let value = arguments["value"] as? String,
                let data = value.data(using: .utf8) else {
                return
            }
            do {
                try getScreenObjectBySnapshot(data)
                result(nil)
            } catch {
                result(nil)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }

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
