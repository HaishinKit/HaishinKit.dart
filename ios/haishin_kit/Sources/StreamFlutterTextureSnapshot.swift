import Foundation
import AVFoundation

struct StreamFlutterTextureSnapshot: Codable, Sendable {
    enum VideoGravity: String, Codable, Sendable {
        case resize
        case resizeAspect
        case resizeAspectFill
        
        var rawValue: AVLayerVideoGravity {
            switch self {
            case .resize:
                return AVLayerVideoGravity.resize
            case .resizeAspect:
                return AVLayerVideoGravity.resizeAspect
            case .resizeAspectFill:
                return AVLayerVideoGravity.resizeAspectFill
            }
        }
    }

    let width: Double
    let height: Double
    let videoGravity: VideoGravity
}

