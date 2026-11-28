package com.haishinkit.haishin_kit

import android.content.Context
import android.graphics.BitmapFactory
import android.net.Uri
import android.media.MediaMetadataRetriever
import android.util.Base64
import com.haishinkit.screen.ScreenObject
import com.haishinkit.screen.ScreenObjectContainer
import com.haishinkit.screen.AssetScreenObject
import com.haishinkit.screen.VideoScreenObject
import com.haishinkit.screen.scene.SceneFile
import com.haishinkit.screen.scene.ScreenObjectSnapshot
import java.io.File
import java.security.MessageDigest
import java.util.UUID

/** Per-screen media storage; native SceneFile owns archive validation/serialization. */
internal class ScreenSceneFiles(private val context: Context) {
    private val folder = File(context.cacheDir, "flutter-scene-${UUID.randomUUID()}").apply { check(mkdirs()) }
    private var resources: Map<String, ByteArray> = emptyMap()
    private var importedFolder: File? = null

    fun cacheAsset(bytes: ByteArray, extension: String): String {
        require(bytes.size <= MAX_BYTES && extension.matches(Regex("[a-zA-Z0-9]{1,8}"))) { "Invalid asset size or extension" }
        val file = File(folder, "asset-${UUID.randomUUID()}.$extension")
        file.writeBytes(bytes)
        return Uri.fromFile(file).toString()
    }

    fun encode(snapshot: ScreenObjectSnapshot): ByteArray {
        val media = resources.toMutableMap()
        var total = media.values.sumOf { it.size.toLong() }
        fun portable(node: ScreenObjectSnapshot): ScreenObjectSnapshot {
            var elements = node.elements
            if (node.type in setOf("image", "asset")) {
                val source = elements["source"].orEmpty()
                if (!source.startsWith("data:") && !source.startsWith("media/")) {
                    val uri = Uri.parse(source)
                    require(uri.scheme == "file") { "Only local files can be packaged" }
                    val original = importedFolder?.let { base -> media.keys.firstOrNull { Uri.fromFile(File(base, it)) == uri } }
                    val name = original ?: run {
                        val file = File(requireNotNull(uri.path))
                        require(file.length() <= MAX_BYTES - total) { "Scene media exceeds 32 MiB" }
                        val bytes = file.inputStream().use { it.readBytes() }
                        val extension = file.extension.lowercase().takeIf { it.matches(Regex("[a-z0-9]{1,8}")) } ?: "bin"
                        val digest = MessageDigest.getInstance("SHA-256").digest(bytes).joinToString("") { "%02x".format(it) }
                        "asset-$digest.$extension".also { name ->
                            if (!media.containsKey(name)) { media[name] = bytes; total += bytes.size }
                        }
                    }
                    elements = elements + ("source" to "media/$name")
                }
            }
            return node.copy(elements = elements, children = node.children.map(::portable))
        }
        return SceneFile(portable(snapshot), media).write().also { require(it.size <= MAX_BYTES) { "Scene exceeds 32 MiB" } }
    }

    fun prepare(bytes: ByteArray): Loaded {
        require(bytes.size <= MAX_BYTES) { "Scene exceeds 32 MiB" }
        val file = SceneFile.read(bytes)
        require(file.resources.values.sumOf { it.size.toLong() } <= MAX_BYTES) { "Scene media exceeds 32 MiB" }
        val root = file.snapshot
        require(root.type in setOf("screen", "container")) { "Expected a composition root" }
        require(root.size.width in 1..4096 && root.size.height in 1..4096 && root.size.width.toLong() * root.size.height <= 8_388_608) { "Unsupported scene dimensions" }
        val directory = File(folder, "import-${UUID.randomUUID()}").apply { check(mkdirs()) }
        try {
            file.resources.forEach { (name, data) -> File(directory, name).writeBytes(data) }
            val ids = mutableSetOf<String>()
            var pixels = 0L
            var videos = 0
            fun resolve(node: ScreenObjectSnapshot, depth: Int): ScreenObjectSnapshot {
                require(depth <= 32 && ids.add(node.id) && ids.size <= 256) { "Invalid scene hierarchy or IDs" }
                require(node.size.width in 0..4096 && node.size.height in 0..4096 && node.cornerRadius.isFinite() && node.cornerRadius >= 0) { "Invalid object dimensions" }
                var elements = node.elements
                if (node.type in setOf("image", "asset")) {
                    val source = elements["source"].orEmpty()
                    if (source.startsWith("media/")) {
                        elements = elements + ("source" to Uri.fromFile(File(directory, source.removePrefix("media/"))).toString())
                    }
                    if (node.type == "image") {
                        val options = BitmapFactory.Options().apply { inJustDecodeBounds = true }
                        if (source.startsWith("data:")) {
                            val image = Base64.decode(source.substringAfter("base64,"), Base64.DEFAULT)
                            BitmapFactory.decodeByteArray(image, 0, image.size, options)
                        } else {
                            BitmapFactory.decodeFile(Uri.parse(elements.getValue("source")).path, options)
                        }
                        require(options.outWidth > 0 && options.outHeight > 0) { "Unreadable scene image" }
                        pixels += options.outWidth.toLong() * options.outHeight
                        require(pixels <= 16_777_216) { "Scene images exceed supported size" }
                    } else if (elements["format"] in listOf(null, "video")) {
                        videos += 1
                        require(videos <= 4) { "Too many video assets" }
                        val metadata = MediaMetadataRetriever()
                        try {
                            metadata.setDataSource(context, Uri.parse(elements.getValue("source")))
                            require(metadata.extractMetadata(MediaMetadataRetriever.METADATA_KEY_HAS_VIDEO) == "yes") { "Unreadable video asset" }
                        } finally { metadata.release() }
                    }
                }
                return node.copy(elements = elements, children = node.children.map { resolve(it, depth + 1) })
            }
            return Loaded(file, resolve(root, 0), directory)
        } catch (error: Throwable) { directory.deleteRecursively(); throw error }
    }

    fun install(loaded: Loaded) {
        // Keep previous media until screen disposal: an in-flight render/decoder
        // can still own a previous scene during the transition.
        resources = loaded.file.resources
        importedFolder = loaded.directory
    }

    fun close() { folder.deleteRecursively() }

    data class Loaded(val file: SceneFile, val snapshot: ScreenObjectSnapshot, val directory: File)
    companion object {
        const val MAX_BYTES = 32 * 1024 * 1024
        fun closeAssets(root: ScreenObject) {
            if (root is AssetScreenObject) root.close()
            if (root is ScreenObjectContainer) root.getChildren().forEach(::closeAssets)
        }
        fun configureCameras(root: ScreenObject) {
            if (root is VideoScreenObject && root !is AssetScreenObject) root.isRotatesWithContent = true
            if (root is ScreenObjectContainer) root.getChildren().forEach(::configureCameras)
        }
    }
}
