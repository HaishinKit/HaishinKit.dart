#if os(iOS)
import AVFoundation
import Flutter
import HaishinKit
import UIKit

@MainActor
final class HdrViewFactory: NSObject, @preconcurrency FlutterPlatformViewFactory {
    private weak var plugin: HaishinKitPlugin?

    init(plugin: HaishinKitPlugin) {
        self.plugin = plugin
        super.init()
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> any FlutterPlatformView {
        guard #available(iOS 16.0, *),
              let parameters = args as? [String: Any],
              let memory = parameters["memory"] as? Int,
              let handler = plugin?.handlers[memory] as? StreamSessionHandler,
              handler.dynamicRangeMode == .hlg else {
            return EmptyPlatformView(frame: frame)
        }
        return HdrPlatformView(frame: frame, handler: handler, gravity: parameters["videoGravity"] as? String)
    }
}

@MainActor
private final class HdrPlatformView: NSObject, @preconcurrency FlutterPlatformView {
    private let nativeView: MTHKView
    private weak var handler: StreamSessionHandler?

    init(frame: CGRect, handler: StreamSessionHandler, gravity: String?) {
        nativeView = MTHKView(frame: frame)
        self.handler = handler
        super.init()
        nativeView.setDynamicRangeMode(.hdr)
        switch gravity {
        case "resize": nativeView.videoGravity = .resize
        case "resizeAspectFill": nativeView.videoGravity = .resizeAspectFill
        default: nativeView.videoGravity = .resizeAspect
        }
        handler.addHdrOutput(nativeView)
    }

    func view() -> UIView { nativeView }

    deinit {
        let view = nativeView
        let owner = handler
        Task { @MainActor in owner?.removeHdrOutput(view) }
    }
}

@MainActor
private final class EmptyPlatformView: NSObject, @preconcurrency FlutterPlatformView {
    private let nativeView: UIView

    init(frame: CGRect) {
        nativeView = UIView(frame: frame)
        super.init()
        nativeView.backgroundColor = .black
    }

    func view() -> UIView { nativeView }
}
#endif
