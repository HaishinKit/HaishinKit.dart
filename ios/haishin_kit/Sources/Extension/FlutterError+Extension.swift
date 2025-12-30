import HaishinKit

#if canImport(Flutter)
import Flutter
#endif
#if canImport(FlutterMacOS)
import FlutterMacOS
#endif

extension FlutterError {
    convenience init(_ error: Swift.Error, message: String? = nil, details: Any? = nil) {
        let code: String
        switch error {
        case let error as MediaMixer.Error:
            code = String(describing: error)
        default:
            code = "UNKNOWN"
        }
        self.init(code: code, message: message, details: details)
    }
}
