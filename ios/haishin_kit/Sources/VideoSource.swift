import Foundation

struct VideoSource: Codable, Sendable {
    enum CameraPosition: String, Codable {
        case front
        case back
        case unspecified
    }

    let id: String
    let name: String?
    let position: CameraPosition
}
