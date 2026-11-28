import Foundation
import HaishinKit

struct MediaMixerOptions: Codable, Sendable {
    let captureSessionMode: MediaMixer.CaptureSessionMode
    let multiTrackAudioMixingEnabled: Bool
    let dynamicRangeMode: PluginDynamicRangeMode

    init(captureSessionMode: MediaMixer.CaptureSessionMode = .single, multiTrackAudioMixingEnabled: Bool = false,
         dynamicRangeMode: PluginDynamicRangeMode = .sdr) {
        self.captureSessionMode = captureSessionMode
        self.multiTrackAudioMixingEnabled = multiTrackAudioMixingEnabled
        self.dynamicRangeMode = dynamicRangeMode
    }

    private enum CodingKeys: String, CodingKey {
        case captureSessionMode, multiTrackAudioMixingEnabled, dynamicRangeMode
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        captureSessionMode = try values.decodeIfPresent(MediaMixer.CaptureSessionMode.self, forKey: .captureSessionMode) ?? .single
        multiTrackAudioMixingEnabled = try values.decodeIfPresent(Bool.self, forKey: .multiTrackAudioMixingEnabled) ?? false
        dynamicRangeMode = try values.decodeIfPresent(PluginDynamicRangeMode.self, forKey: .dynamicRangeMode) ?? .sdr
    }
}
