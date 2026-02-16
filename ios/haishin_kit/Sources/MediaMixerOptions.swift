import Foundation
import HaishinKit

struct MediaMixerOptions: Codable, Sendable {
    let captureSessionMode: MediaMixer.CaptureSessionMode
    let multiTrackAudioMixingEnabled: Bool

    init(captureSessionMode: MediaMixer.CaptureSessionMode = .single, multiTrackAudioMixingEnabled: Bool = false) {
        self.captureSessionMode = captureSessionMode
        self.multiTrackAudioMixingEnabled = multiTrackAudioMixingEnabled
    }
}
