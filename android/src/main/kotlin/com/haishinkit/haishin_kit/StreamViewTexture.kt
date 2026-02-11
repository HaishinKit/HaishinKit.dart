package com.haishinkit.haishin_kit

import android.util.Size
import com.haishinkit.graphics.PixelTransform
import com.haishinkit.graphics.VideoGravity
import com.haishinkit.graphics.effect.VideoEffect
import com.haishinkit.media.MediaBuffer
import com.haishinkit.media.MediaOutputDataSource
import com.haishinkit.view.StreamView
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.view.TextureRegistry
import java.lang.ref.WeakReference

class StreamViewTexture(binding: FlutterPlugin.FlutterPluginBinding) :
    StreamView, TextureRegistry.SurfaceProducer.Callback {
    override var videoGravity: VideoGravity
        get() = pixelTransform.videoGravity
        set(value) {
            pixelTransform.videoGravity = value
        }

    override var dataSource: WeakReference<MediaOutputDataSource>? = null
        set(value) {
            field = value
            pixelTransform.screen = value?.get()?.screen
        }

    override var frameRate: Int
        get() = pixelTransform.frameRate
        set(value) {
            pixelTransform.frameRate = value
        }

    override var videoEffect: VideoEffect
        get() = pixelTransform.videoEffect
        set(value) {
            pixelTransform.videoEffect = value
        }

    val id: Long?
        get() = producer?.id()

    var imageExtent: Size
        get() = pixelTransform.imageExtent
        set(value) {
            if (this.size == value) return
            this.size = value

            pixelTransform.videoGravity = VideoGravity.RESIZE_ASPECT_FILL
            pixelTransform.imageExtent = value
            // For SurfaceProducer, we need to recreate the surface with new size
            recreateSurface()
        }

    private val pixelTransform: PixelTransform by lazy {
        PixelTransform.create(binding.applicationContext)
    }

    private val flutterPluginBinding = binding

    override fun append(buffer: MediaBuffer) {}

    private var producer: TextureRegistry.SurfaceProducer? = null
    private var size: Size? = null
    private val surfaceLock = Object()

    init {
        createSurfaceProducer()
    }

    private fun createSurfaceProducer() {
        // Skipping creating surface without a size
        if (size == null) {
            return
        }

        synchronized(surfaceLock) {
            val producer = flutterPluginBinding.textureRegistry.createSurfaceProducer()
            size!!.let { producer.setSize(it.width, it.height) }
            producer.setCallback(this)

            this.producer = producer

            // Set surface only after producer is fully initialized and valid
            val surface = producer.surface
            if (surface.isValid) {
                pixelTransform.surface = surface
            }
        }
    }

    private fun recreateSurface() {
        synchronized(surfaceLock) {
            // Clean up existing surface first - this stops the background thread from using it
            pixelTransform.surface = null

            // Release the old producer
            producer?.release()
            producer = null

            // Create new producer with new size
            createSurfaceProducer()
        }
    }

    override fun onSurfaceAvailable() {
        synchronized(surfaceLock) {
            // Initialize surface and draw current frame
            val surface = producer?.surface
            if (surface != null && surface.isValid) {
                pixelTransform.surface = surface
            }
        }
    }

    override fun onSurfaceCleanup() {
        synchronized(surfaceLock) {
            // Clean up surface and stop drawing frames
            pixelTransform.surface = null
        }
    }

    fun dispose() {
        synchronized(surfaceLock) {
            pixelTransform.surface = null
            producer?.release()
            producer = null
        }
    }
}