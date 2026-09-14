package com.haishinkit.haishin_kit

import android.graphics.Rect
import com.haishinkit.graphics.ImageOrientation
import com.haishinkit.screen.VideoScreenObject
import android.util.Log
import com.haishinkit.screen.Screen
import com.haishinkit.screen.ScreenObject
import com.haishinkit.screen.ScreenObjectFactory
import com.haishinkit.screen.scene.ScreenObjectSnapshot
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.serialization.json.Json

class ScreenHandler(
    private var plugin: HaishinKitPlugin?,
    private var screen: Screen?
) : MethodChannel.MethodCallHandler {
    private var json = Json {
        ignoreUnknownKeys = true
    }

    private var screenObjectFactory: ScreenObjectFactory = ScreenObjectFactory()

    override fun onMethodCall(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        when (call.method) {
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

            "$TAG#dispose" -> {
                plugin?.onDispose(hashCode())
                plugin = null
                screen = null
                result.success(null)
            }
        }
    }

    private fun getScreenObjectBySnapshot(value: String): ScreenObject {
        val snapshot = json.decodeFromString<ScreenObjectSnapshot>(value)
        val screenObject =
            screen?.findById(snapshot.id) ?: return screenObjectFactory.create(snapshot)
        screenObject.isVisible = snapshot.isVisible
        screenObject.layoutMargin.set(snapshot.layoutMargin)
        screenObject.horizontalAlignment = snapshot.horizontalAlignment
        screenObject.verticalAlignment = snapshot.verticalAlignment
        screenObject.elements = snapshot.elements
        applyVideoOrientation(screenObject, snapshot.elements)
        return screenObject
    }

    /**
     * Applies the orientation elements to a [VideoScreenObject].
     *
     * [VideoScreenObject] already supports imageOrientation, deviceOrientation
     * and rotatesWithContent, but its own `elements` setter reads only `track`,
     * so none of them can be reached from Dart. Without deviceOrientation the
     * capture keeps whatever rotation it had when the video source was
     * attached, and a device held in landscape renders rotated by 90 degrees.
     */
    private fun applyVideoOrientation(
        screenObject: ScreenObject,
        elements: Map<String, String>,
    ) {
        if (screenObject !is VideoScreenObject) return
        elements["deviceOrientation"]?.toIntOrNull()?.let {
            screenObject.deviceOrientation = it
        }
        elements["rotatesWithContent"]?.let {
            screenObject.isRotatesWithContent = it.toBoolean()
        }
        elements["imageOrientation"]?.let { name ->
            val orientation = when (name.lowercase()) {
                "up" -> ImageOrientation.UP
                "down" -> ImageOrientation.DOWN
                "left" -> ImageOrientation.LEFT
                "right" -> ImageOrientation.RIGHT
                else -> null
            }
            if (orientation != null) screenObject.imageOrientation = orientation
        }
    }

    private companion object {
        private const val TAG = "Screen"
        const val INVALID_ARGUMENTS = "INVALID_ARGUMENTS"
    }
}