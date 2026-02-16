import Foundation
#if canImport(Flutter)
import Flutter
#endif
#if canImport(FlutterMacOS)
import FlutterMacOS
#endif

enum PluginUtil {
    static func decode<T: Decodable>(
        call: FlutterMethodCall
    ) throws -> T {
        guard
            let arguments = call.arguments as? [String: Any],
            let value = arguments["value"] as? String,
            let data = value.data(using: .utf8)
        else {
            throw NSError(
                domain: "PluginUtil",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid arguments"]
            )
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
