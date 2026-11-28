import Foundation
import HaishinKit

enum PluginDynamicRangeMode: String, Codable, Sendable {
    case sdr
    case hlg

    var nativeValue: HaishinKit.DynamicRangeMode {
        self == .hlg ? .hdr : .sdr
    }

    var isSupported: Bool {
        if self == .sdr { return true }
        #if os(iOS)
        if #available(iOS 16.0, *) { return true }
        #endif
        return false
    }

    func validate() throws {
        guard !isSupported else { return }
        throw NSError(domain: "HaishinKit", code: -1, userInfo: [
            NSLocalizedDescriptionKey: "HLG requires iOS 16 or newer in this Flutter plugin."
        ])
    }
}
