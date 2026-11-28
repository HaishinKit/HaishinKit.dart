package com.haishinkit.haishin_kit

import android.content.Context
import android.content.pm.ActivityInfo
import android.graphics.PixelFormat
import android.os.Build
import android.util.Size
import android.view.SurfaceHolder
import android.view.SurfaceView
import android.view.View
import android.view.Window
import com.haishinkit.graphics.PixelTransform
import com.haishinkit.graphics.VideoGravity
import com.haishinkit.graphics.effect.VideoEffect
import com.haishinkit.media.MediaBuffer
import com.haishinkit.media.MediaOutputDataSource
import com.haishinkit.view.StreamView
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.lang.ref.WeakReference
import java.util.WeakHashMap

/** A real 10-bit SurfaceView, never a Flutter 8-bit texture or virtual display. */
internal class HdrViewFactory(private val plugin: HaishinKitPlugin) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    private val views = mutableSetOf<HdrPlatformView>()
    private var window: Window? = null
    private var windowLease: HdrWindowLease? = null

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        require(Build.VERSION.SDK_INT >= 33) { "HDR previews require Android 13 or newer" }
        val parameters = requireNotNull(args as? Map<*, *>) { "HDR view parameters are required" }
        val memory = requireNotNull(parameters["memory"] as? Number).toInt()
        val handler = plugin.sessionHandler(memory) ?: return EmptyPlatformView(context)
        requireNotNull(window) { "HDR previews require an attached Activity" }
        val gravity = when (parameters["videoGravity"]) {
            "resize" -> VideoGravity.RESIZE
            "resizeAspectFill" -> VideoGravity.RESIZE_ASPECT_FILL
            else -> VideoGravity.RESIZE_ASPECT
        }
        val view = HdrPlatformView(context, handler, gravity) { disposed ->
            views.remove(disposed)
            updateWindow()
        }
        views.add(view)
        try {
            updateWindow()
        } catch (error: Exception) {
            view.dispose()
            throw error
        }
        return view
    }

    fun setWindow(value: Window?) {
        if (window === value) return
        restoreWindow()
        window = value
        updateWindow()
    }

    fun dispose() {
        views.toList().forEach { it.dispose() }
        restoreWindow()
        window = null
    }

    fun disposeSession(handler: StreamSessionHandler) {
        views.filter { it.belongsTo(handler) }.forEach { it.dispose() }
    }

    private fun updateWindow() {
        if (Build.VERSION.SDK_INT < 33) return
        val activeWindow = window ?: return
        if (views.isEmpty()) {
            restoreWindow()
        } else if (windowLease == null) {
            windowLease = HdrWindowLease.acquire(activeWindow)
        }
    }

    private fun restoreWindow() {
        if (Build.VERSION.SDK_INT < 33) return
        windowLease?.close()
        windowLease = null
    }
}

private class EmptyPlatformView(context: Context) : PlatformView {
    private val nativeView = View(context).apply { setBackgroundColor(android.graphics.Color.BLACK) }

    override fun getView(): View = nativeView

    override fun dispose() = Unit
}

private class HdrPlatformView(
    context: Context,
    private val handler: StreamSessionHandler,
    gravity: VideoGravity,
    private val onDispose: (HdrPlatformView) -> Unit,
) : PlatformView {
    private val output = HdrSurfaceOutput(context).apply { videoGravity = gravity }
    private var disposed = false

    init {
        handler.registerHdrView(output)
    }

    override fun getView(): View = output

    fun belongsTo(value: StreamSessionHandler): Boolean = handler === value

    override fun dispose() {
        if (disposed) return
        disposed = true
        handler.unregisterHdrView(output)
        output.close()
        onDispose(this)
    }
}

/** Flutter's platform view and Activity callbacks run on the main thread. */
@androidx.annotation.RequiresApi(33)
private class HdrWindowLease private constructor(private val window: Window) : AutoCloseable {
    private var closed = false

    override fun close() {
        if (closed) return
        closed = true
        val state = windows[window] ?: return
        state.count -= 1
        if (state.count == 0) {
            window.colorMode = state.originalMode
            windows.remove(window)
        }
    }

    private data class State(val originalMode: Int, var count: Int)

    companion object {
        private val windows = WeakHashMap<Window, State>()

        fun acquire(window: Window): HdrWindowLease {
            val state = windows[window]
            if (state == null) {
                val originalMode = window.colorMode
                window.colorMode = ActivityInfo.COLOR_MODE_HDR
                windows[window] = State(originalMode, 1)
            } else {
                state.count += 1
            }
            return HdrWindowLease(window)
        }
    }
}

private class HdrSurfaceOutput(context: Context) : SurfaceView(context), StreamView, SurfaceHolder.Callback {
    override var dataSource: WeakReference<MediaOutputDataSource>? = null
        set(value) {
            field = value
            if (!closed) transform.screen = value?.get()?.screen
        }
    override var videoGravity: VideoGravity
        get() = transform.videoGravity
        set(value) { if (!closed) transform.videoGravity = value }
    override var frameRate: Int
        get() = transform.frameRate
        set(value) { if (!closed) transform.frameRate = value }
    override var videoEffect: VideoEffect
        get() = transform.videoEffect
        set(value) { if (!closed) transform.videoEffect = value }

    private val transform = PixelTransform.createOpenGL(context.applicationContext)
    private var closed = false

    init {
        holder.setFormat(PixelFormat.RGBA_1010102)
        holder.addCallback(this)
    }

    override fun surfaceCreated(holder: SurfaceHolder) {
        if (closed) return
        transform.imageExtent = Size(width, height)
        transform.surface = holder.surface
    }

    override fun surfaceChanged(holder: SurfaceHolder, format: Int, width: Int, height: Int) {
        if (!closed) transform.imageExtent = Size(width, height)
    }

    override fun surfaceDestroyed(holder: SurfaceHolder) {
        if (!closed) transform.surface = null
    }

    override fun append(buffer: MediaBuffer) = Unit

    fun close() {
        if (closed) return
        closed = true
        holder.removeCallback(this)
        dataSource = null
        transform.close()
    }
}
