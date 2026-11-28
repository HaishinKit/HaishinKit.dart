import CoreVideo
import Foundation
import VideoToolbox

enum NativeVideoCodecs {
    /// Lists OS encoders, not decoder availability or remote-server support.
    static func supported(range: PluginDynamicRangeMode) throws -> [String] {
        guard range.isSupported else { return [] }
        if range == .hlg { return supportsMain10() ? ["hevc"] : [] }
        var list: CFArray?
        let status = VTCopyVideoEncoderList(nil, &list)
        guard status == noErr, let records = list as? [[String: Any]] else {
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil)
        }
        let types = Set(records.compactMap {
            ($0[kVTVideoEncoderList_CodecType as String] as? NSNumber)?.uint32Value
        })
        return [("h264", kCMVideoCodecType_H264), ("hevc", kCMVideoCodecType_HEVC)]
            .filter { types.contains($0.1) }.map(\.0)
    }

    private static func supportsMain10() -> Bool {
        var session: VTCompressionSession?
        let attributes = [
            kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_420YpCbCr10BiPlanarVideoRange),
        ] as CFDictionary
        let status = VTCompressionSessionCreate(
            allocator: kCFAllocatorDefault, width: 1280, height: 720,
            codecType: kCMVideoCodecType_HEVC, encoderSpecification: nil,
            imageBufferAttributes: attributes, compressedDataAllocator: nil,
            outputCallback: nil, refcon: nil, compressionSessionOut: &session)
        guard status == noErr, let session else { return false }
        defer { VTCompressionSessionInvalidate(session) }
        guard VTSessionSetProperty(session, key: kVTCompressionPropertyKey_ProfileLevel,
                                   value: kVTProfileLevel_HEVC_Main10_AutoLevel) == noErr else { return false }
        return VTCompressionSessionPrepareToEncodeFrames(session) == noErr
    }
}
