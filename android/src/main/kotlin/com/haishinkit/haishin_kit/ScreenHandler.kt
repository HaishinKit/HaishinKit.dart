package com.haishinkit.haishin_kit

import android.graphics.Rect
import android.util.Log
import com.haishinkit.screen.Screen
import com.haishinkit.screen.ScreenObject
import com.haishinkit.screen.ScreenObjectFactory
import com.haishinkit.screen.scene.ScreenObjectSnapshot
import com.haishinkit.screen.scene.ScreenObjectSnapshotFactory
import com.haishinkit.screen.AssetScreenObject
import com.haishinkit.screen.ScreenObjectContainer
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.serialization.json.Json
import kotlinx.coroutines.*
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import java.util.concurrent.atomic.AtomicBoolean
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException

class ScreenHandler(
    private var plugin: HaishinKitPlugin?,
    private var screen: Screen?
) : MethodChannel.MethodCallHandler {
    private var json = Json {
        ignoreUnknownKeys = true
    }

    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main.immediate)
    private val sceneMutex = Mutex()
    private val files = ScreenSceneFiles(requireNotNull(plugin).flutterPluginBinding.applicationContext)
    private var screenObjectFactory = ScreenObjectFactory(requireNotNull(plugin).flutterPluginBinding.applicationContext)
    private var disposed = false
    private var containsAssets = false

    private fun hasAsset(node: ScreenObjectSnapshot): Boolean = node.type == "asset" || node.children.any(::hasAsset)

    private fun sceneOperation(result: MethodChannel.Result, operation: suspend () -> Any?) {
        scope.launch {
            try {
                val value = sceneMutex.withLock {
                    check(!disposed) { "Screen is disposed" }
                    operation()
                }
                result.success(value)
            } catch (error: Exception) {
                result.error("SCENE_ERROR", error.message ?: "Scene operation failed", null)
            }
        }
    }

    private suspend fun <T> onFrame(operation: (Screen) -> T): T {
        val active = checkNotNull(screen) { "Screen is disposed" }
        val once = AtomicBoolean()
        lateinit var callback: Screen.Callback
        try {
            return withTimeout(5000) {
                suspendCancellableCoroutine { continuation ->
                    callback = object : Screen.Callback() {
                        override fun onEnterFrame() {
                            if (!once.compareAndSet(false, true) || !continuation.isActive) return
                            runCatching { operation(active) }
                                .onSuccess { continuation.resume(it) }
                                .onFailure { continuation.resumeWithException(it) }
                        }
                    }
                    active.registerCallback(callback)
                }
            }
        } finally {
            active.unregisterCallback(callback)
        }
    }

    private fun capture(root: ScreenObject): ScreenObjectSnapshot {
        val value = ScreenObjectSnapshotFactory().create(root)
        val margin = value.layoutMargin.copy()
        if (root.horizontalAlignment == ScreenObject.HORIZONTAL_ALIGNMENT_LEFT) margin.left += root.frame.left
        if (root.verticalAlignment == ScreenObject.VERTICAL_ALIGNMENT_TOP) margin.top += root.frame.top
        return value.copy(layoutMargin = margin, children =
            if (root is ScreenObjectContainer) root.getChildren().map(::capture) else value.children)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        when (call.method) {
            "$TAG#cacheAsset" -> sceneOperation(result) {
                val bytes = requireNotNull(call.argument<ByteArray>("bytes"))
                val extension = requireNotNull(call.argument<String>("extension"))
                withContext(Dispatchers.IO) { files.cacheAsset(bytes, extension) }
            }
            "$TAG#exportScene" -> sceneOperation(result) {
                val snapshot = onFrame { capture(it) }
                withContext(Dispatchers.IO) { files.encode(snapshot) }
            }
            "$TAG#importScene" -> sceneOperation(result) {
                val bytes = requireNotNull(call.argument<ByteArray>("bytes"))
                val loaded = withContext(Dispatchers.IO) { files.prepare(bytes) }
                try {
                    val container = screenObjectFactory.create(loaded.snapshot) as ScreenObjectContainer
                    containsAssets = containsAssets || hasAsset(loaded.snapshot)
                    ScreenSceneFiles.configureCameras(container)
                    val response = json.encodeToString(loaded.snapshot)
                    val active = checkNotNull(screen)
                    // A timed-out preparation must not stop the current scene.
                    val previous = onFrame { value -> value.getChildren() }
                    active.transition(container)
                    active.frame = Rect(0, 0, loaded.snapshot.size.width, loaded.snapshot.size.height)
                    files.install(loaded)
                    runCatching { previous.forEach(ScreenSceneFiles::closeAssets) }
                        .onFailure { Log.w(TAG, "Could not release video assets from the previous scene", it) }
                    response
                } catch (error: Exception) {
                    // The prepared directory may already belong to the render thread.
                    // Keep it screen-owned until disposal even after an acknowledgement timeout.
                    throw error
                }
            }
            "$TAG#setSize" -> {
                val value = call.argument<String>("value")
                if (value == null) {
                    result.error(INVALID_ARGUMENTS, null, null)
                } else {
                    val size = json.decodeFromString<ScreenObjectSnapshot.Size>(value)
                    screen?.frame = Rect(0, 0, size.width, size.height)
                    result.success(null)
                }
            }
            "$TAG#addChild" -> {
                val value = call.argument<String>("value")
                if (value == null) {
                    result.error(INVALID_ARGUMENTS, null, null)
                } else {
                    val snapshot = json.decodeFromString<ScreenObjectSnapshot>(value)
                    containsAssets = containsAssets || hasAsset(snapshot)
                    screen?.addChild(screenObjectFactory.create(snapshot))
                    result.success(null)
                }
            }

            "$TAG#removeChild" -> {
                val value = call.argument<String>("value")
                if (value == null) {
                    result.error(INVALID_ARGUMENTS, null, null)
                } else {
                    val screenObject = screen?.findById(value)
                    screenObject?.let(ScreenSceneFiles::closeAssets)
                    screenObject?.parent?.removeChild(screenObject)
                    result.success(null)
                }
            }

            "$TAG#layout" -> {
                val value = call.argument<String>("value")
                if (value == null) {
                    result.error(INVALID_ARGUMENTS, null, null)
                } else {
                    getScreenObjectBySnapshot(value)
                    result.success(null)
                }
            }

            "$TAG#getBounds" -> {
                val ids = call.argument<List<String>>("ids")
                if (ids == null) {
                    result.error(INVALID_ARGUMENTS, null, null)
                } else {
                    val values = ids.mapNotNull { id ->
                        screen?.findById(id)?.bounds?.let { bounds ->
                            id to listOf(bounds.left.toDouble(), bounds.top.toDouble(), bounds.right.toDouble(), bounds.bottom.toDouble())
                        }
                    }.toMap()
                    result.success(values)
                }
            }

            "$TAG#dispose" -> {
                sceneOperation(result) {
                    if (containsAssets) runCatching { onFrame { value -> value.getChildren().forEach(ScreenSceneFiles::closeAssets) } }
                    disposed = true
                    plugin?.onDispose(hashCode())
                    plugin = null
                    screen = null
                    withContext(Dispatchers.IO) { files.close() }
                    null
                }
            }
        }
    }

    private fun getScreenObjectBySnapshot(value: String): ScreenObject {
        val snapshot = json.decodeFromString<ScreenObjectSnapshot>(value)
        val screenObject =
            screen?.findById(snapshot.id) ?: return screenObjectFactory.create(snapshot)
        screenObject.frame = Rect(0, 0, snapshot.size.width, snapshot.size.height)
        screenObject.isVisible = snapshot.isVisible
        screenObject.cornerRadius = snapshot.cornerRadius
        screenObject.layoutMargin.set(snapshot.layoutMargin)
        screenObject.horizontalAlignment = snapshot.horizontalAlignment
        screenObject.verticalAlignment = snapshot.verticalAlignment
        val elements = if (screenObject is AssetScreenObject) mapOf(
            "source" to snapshot.elements["source"].orEmpty(),
            "looping" to (snapshot.elements["looping"] == "true").toString(),
            "videoGravity" to (snapshot.elements["videoGravity"] ?: "resizeAspect"),
        ) else snapshot.elements
        if (screenObject.elements != elements) screenObject.elements = elements
        screenObject.invalidateLayout()
        return screenObject
    }

    private companion object {
        private const val TAG = "Screen"
        const val INVALID_ARGUMENTS = "INVALID_ARGUMENTS"
    }
}
