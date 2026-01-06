import Foundation

struct PluginAudioMixerSettings: Codable {
    let channels: UInt32
    let isMuted: Bool
    let mainTrack: UInt8
    let maximumNumberOfChannels: Int
    let sampleRate: Float64
}
