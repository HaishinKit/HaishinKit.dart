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

    @ScreenActor
    private lazy var sceneFiles = ScreenSceneFiles()

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
        case "Screen#cacheAsset":
            guard let bytes = arguments["bytes"] as? FlutterStandardTypedData,
                let suffix = arguments["extension"] as? String else {
                result(ErrorCode.invalidArgument.makeFlutterError()); return
            }
            Task { @ScreenActor in
                guard screen != nil else { result(ErrorCode.invalidArgument.makeFlutterError("Screen is disposed")); return }
                do { result(try sceneFiles.cacheAsset(bytes.data, extension: suffix)) }
                catch { result(ErrorCode.invalidArgument.makeFlutterError("Could not cache video: \(error)")) }
            }
        case "Screen#exportScene":
            Task { @ScreenActor in
                guard let screen else { result(ErrorCode.invalidArgument.makeFlutterError("Screen is disposed")); return }
                do { result(FlutterStandardTypedData(bytes: try sceneFiles.encoded(screen))) }
                catch { result(ErrorCode.invalidArgument.makeFlutterError("Could not export scene: \(error)")) }
            }
        case "Screen#importScene":
            guard let bytes = arguments["bytes"] as? FlutterStandardTypedData else {
                result(ErrorCode.invalidArgument.makeFlutterError()); return
            }
            Task { @ScreenActor in
                guard let screen else { result(ErrorCode.invalidArgument.makeFlutterError("Screen is disposed")); return }
                do { result(try sceneFiles.restore(bytes.data, screen: screen)) }
                catch { result(ErrorCode.invalidArgument.makeFlutterError("Could not restore scene: \(error)")) }
            }
        case "Screen#setSize":
            guard
                let value = arguments["value"] as? String,
                let data = value.data(using: .utf8) else {
                result(ErrorCode.invalidArgument.makeFlutterError())
                return
            }
            Task { @ScreenActor in
                do {
                    let size = try decoder.decode(ScreenObjectSnapshot.Size.self, from: data)
                    screen?.size = CGSize(width: CGFloat(size.width), height: CGFloat(size.height))
                    result(nil)
                } catch {
                    result(ErrorCode.invalidArgument.makeFlutterError())
                }
            }
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
                    @ScreenActor func close(_ node: ScreenObjectSnapshot) {
                        (screen?.findById(node.id) as? AssetScreenObject)?.cancelReading()
                        node.children.forEach(close)
                    }
                    close(ScreenObjectSnapshotFactory().make(screenObject))
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
        case "Screen#getBounds":
            guard let ids = arguments["ids"] as? [String] else {
                result(ErrorCode.invalidArgument.makeFlutterError())
                return
            }
            Task { @ScreenActor in
                var values: [String: [Double]] = [:]
                for id in ids {
                    guard let object = screen?.findById(id) else { continue }
                    let bounds = object.bounds
                    values[id] = [bounds.minX, bounds.minY, bounds.maxX, bounds.maxY].map(Double.init)
                }
                result(values)
            }
        case "Screen#dispose":
            Task { @ScreenActor in
                sceneFiles.close(screen)
                screen = nil
                plugin = nil
                result(nil)
            }
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
        screenObject.cornerRadius = CGFloat(snapshot.cornerRadius ?? 0)
        screenObject.layoutMargin = .init(
            top: CGFloat(snapshot.layoutMargin.top),
            left: CGFloat(snapshot.layoutMargin.left),
            bottom: CGFloat(snapshot.layoutMargin.bottom),
            right: CGFloat(snapshot.layoutMargin.right)
        )
        screenObject.size = .init(width: .init(snapshot.size.width), height: .init(snapshot.size.height))
        screenObject.horizontalAlignment = .init(rawValue: snapshot.horizontalAlignment) ?? .left
        screenObject.verticalAlignment = .init(rawValue: snapshot.verticalAlignment) ?? .top
        let elements = screenObject is AssetScreenObject ? [
            "source": snapshot.elements["source"] ?? "",
            "looping": String(snapshot.elements["looping"] == "true"),
            "videoGravity": snapshot.elements["videoGravity"] ?? "resizeAspect"
        ] : snapshot.elements
        if screenObject.elements != elements { screenObject.elements = elements }
        screenObject.invalidateLayout()
        return screenObject
    }
}
