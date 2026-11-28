import Foundation
import HaishinKit
import ImageIO
import CryptoKit
import AVFoundation

/// Screen-owned materialized media. Native SceneFile validates the ZIP format.
@ScreenActor
final class ScreenSceneFiles {
    static let maximumBytes = 32 * 1024 * 1024
    private let directory = FileManager.default.temporaryDirectory.appendingPathComponent("flutter-scene-\(UUID().uuidString)", isDirectory: true)
    private var resources: [String: Data] = [:]
    private var importedDirectory: URL?
    private var opaqueAssets: [String: ScreenObjectSnapshot] = [:]

    func cacheAsset(_ bytes: Data, extension suffix: String) throws -> String {
        guard bytes.count <= Self.maximumBytes, suffix.range(of: "^[a-zA-Z0-9]{1,8}$", options: .regularExpression) != nil else { throw SceneFile.Error.invalidResource }
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let url = directory.appendingPathComponent("asset-\(UUID().uuidString).\(suffix)")
        try bytes.write(to: url, options: .atomic)
        return url.absoluteString
    }

    func encoded(_ screen: Screen) throws -> Data {
        var media = resources
        var total = media.values.reduce(0) { $0 + $1.count }
        func portable(_ node: ScreenObjectSnapshot) throws -> ScreenObjectSnapshot {
            if let original = opaqueAssets[node.id] { return original }
            var elements = node.elements
            if ["image", "asset"].contains(node.type), let source = elements["source"], !source.hasPrefix("data:"), !source.hasPrefix("media/") {
                guard let url = URL(string: source), url.isFileURL else { throw SceneFile.Error.invalidResource }
                let original = importedDirectory.flatMap { base in media.keys.first { base.appendingPathComponent($0) == url } }
                let name: String
                if let original { name = original } else {
                    let size = try url.resourceValues(forKeys: [.fileSizeKey]).fileSize ?? 0
                    guard size <= Self.maximumBytes - total else { throw SceneFile.Error.sizeLimitExceeded }
                    let data = try Data(contentsOf: url)
                    guard data.count <= Self.maximumBytes - total else { throw SceneFile.Error.sizeLimitExceeded }
                    let digest = SHA256.hash(data: data).map { String(format: "%02x", $0) }.joined()
                    let suffix = url.pathExtension.lowercased()
                    let ext = suffix.range(of: "^[a-z0-9]{1,8}$", options: .regularExpression) == nil ? "bin" : suffix
                    name = "asset-\(digest).\(ext)"
                    if media[name] == nil { media[name] = data; total += data.count }
                }
                elements["source"] = "media/" + name
            }
            return copy(node, elements: elements, children: try node.children.map(portable))
        }
        let captured = ScreenObjectSnapshotFactory().make(screen)
        let root = copy(captured, size: .init(width: Int(screen.size.width), height: Int(screen.size.height)))
        let data = try SceneFile(snapshot: portable(root), resources: media).encoded()
        guard data.count <= Self.maximumBytes else { throw SceneFile.Error.sizeLimitExceeded }
        return data
    }

    func restore(_ bytes: Data, screen: Screen) throws -> String {
        guard bytes.count <= Self.maximumBytes else { throw SceneFile.Error.sizeLimitExceeded }
        let file = try SceneFile(data: bytes)
        guard file.resources.values.reduce(0, { $0 + $1.count }) <= Self.maximumBytes,
            ["screen", "container"].contains(file.snapshot.type),
            (1...4096).contains(file.snapshot.size.width), (1...4096).contains(file.snapshot.size.height),
            file.snapshot.size.width * file.snapshot.size.height <= 8_388_608 else { throw SceneFile.Error.invalidFile }
        let folder = directory.appendingPathComponent("import-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        do {
            for (name, data) in file.resources { try data.write(to: folder.appendingPathComponent(name), options: .atomic) }
            var ids = Set<String>()
            var imagePixels = 0
            var videos = 0
            func resolve(_ node: ScreenObjectSnapshot, depth: Int) throws -> ScreenObjectSnapshot {
                guard depth <= 32, ids.insert(node.id).inserted, ids.count <= 256,
                    (0...4096).contains(node.size.width), (0...4096).contains(node.size.height),
                    (node.cornerRadius ?? 0).isFinite, (node.cornerRadius ?? 0) >= 0 else { throw SceneFile.Error.invalidFile }
                var elements = node.elements
                if ["image", "asset"].contains(node.type), let source = elements["source"] {
                    if source.hasPrefix("media/") { elements["source"] = folder.appendingPathComponent(String(source.dropFirst(6))).absoluteString }
                    if node.type == "image" {
                        let data: Data
                        if source.hasPrefix("data:"), let encoded = source.components(separatedBy: "base64,").last, let decoded = Data(base64Encoded: encoded) { data = decoded }
                        else if let url = URL(string: elements["source"] ?? ""), url.isFileURL { data = try Data(contentsOf: url) }
                        else { throw SceneFile.Error.invalidResource }
                        guard let image = CGImageSourceCreateWithData(data as CFData, nil),
                            let properties = CGImageSourceCopyPropertiesAtIndex(image, 0, nil) as? [CFString: Any],
                            let width = properties[kCGImagePropertyPixelWidth] as? Int,
                            let height = properties[kCGImagePropertyPixelHeight] as? Int,
                            width > 0, height > 0, width <= 16_777_216 / height else { throw SceneFile.Error.invalidResource }
                        imagePixels += width * height
                        guard imagePixels <= 16_777_216 else { throw SceneFile.Error.sizeLimitExceeded }
                    } else if elements["format"] == nil || elements["format"] == "video" {
                        videos += 1
                        guard videos <= 4 else { throw SceneFile.Error.sizeLimitExceeded }
                        guard let url = URL(string: elements["source"] ?? ""),
                            !AVURLAsset(url: url).tracks(withMediaType: .video).isEmpty else { throw SceneFile.Error.invalidResource }
                    }
                }
                return copy(node, elements: elements, children: try node.children.map { try resolve($0, depth: depth + 1) })
            }
            let snapshot = try resolve(file.snapshot, depth: 0)
            let factory = ScreenObjectFactory()
            var nextOpaque: [String: ScreenObjectSnapshot] = [:]
            func renderable(_ node: ScreenObjectSnapshot) -> ScreenObjectSnapshot {
                if node.type == "asset", let format = node.elements["format"], format != "video" {
                    // Preserve unsupported asset formats without asking AVAssetReader
                    // to decode an animation or another platform's custom payload.
                    func original(_ value: ScreenObjectSnapshot) -> ScreenObjectSnapshot? {
                        if value.id == node.id { return value }
                        return value.children.lazy.compactMap(original).first
                    }
                    nextOpaque[node.id] = original(file.snapshot)
                    return copy(node, type: "flutter.unsupportedAsset")
                }
                return copy(node, children: node.children.map(renderable))
            }
            let objects = snapshot.children.compactMap { factory.make(renderable($0)) }
            let response = String(decoding: try JSONEncoder().encode(snapshot), as: UTF8.self)
            let previous = ScreenObjectSnapshotFactory().make(screen)
            closeAssets(screen)
            for child in previous.children { screen.removeChild(screen.findById(child.id)) }
            screen.size = .init(width: snapshot.size.width, height: snapshot.size.height)
            for object in objects { try screen.addChild(object) }
            resources = file.resources
            importedDirectory = folder
            opaqueAssets = nextOpaque
            return response
        } catch {
            try? FileManager.default.removeItem(at: folder)
            throw error
        }
    }

    func closeAssets(_ screen: Screen) {
        func close(_ node: ScreenObjectSnapshot) {
            (screen.findById(node.id) as? AssetScreenObject)?.cancelReading()
            node.children.forEach(close)
        }
        close(ScreenObjectSnapshotFactory().make(screen))
    }

    func close(_ screen: Screen?) {
        if let screen { closeAssets(screen) }
        try? FileManager.default.removeItem(at: directory)
    }

    private func copy(_ node: ScreenObjectSnapshot, type: String? = nil, size: ScreenObjectSnapshot.Size? = nil,
        elements: [String: String]? = nil, children: [ScreenObjectSnapshot]? = nil) -> ScreenObjectSnapshot {
        .init(type: type ?? node.type, id: node.id, size: size ?? node.size, isVisible: node.isVisible,
            layoutMargin: node.layoutMargin, horizontalAlignment: node.horizontalAlignment,
            verticalAlignment: node.verticalAlignment, elements: elements ?? node.elements,
            children: children ?? node.children, cornerRadius: node.cornerRadius)
    }
}
