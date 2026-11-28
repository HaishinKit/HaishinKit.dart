package com.haishinkit.haishin_kit

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.mockito.Mockito
import kotlin.test.Test

/*
 * This demonstrates a simple unit test of the Kotlin portion of this plugin's implementation.
 *
 * Once you have built the plugin's example app, you can run these tests from the command
 * line by running `./gradlew testDebugUnitTest` in the `example/android/` directory, or
 * you can run them directly from IDEs that support JUnit such as Android Studio.
 */

internal class HaishinKitPluginTest {
    @Test
    fun onMethodCall_getPlatformVersion_returnsLibraryIdentifier() {
        val plugin = HaishinKitPlugin()

        val call = MethodCall("getPlatformVersion", null)
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        plugin.onMethodCall(call, mockResult)

        Mockito.verify(mockResult).success("com.haishinkit")
    }

    @Test
    fun onMethodCall_unknownHandle_doesNotRouteToGlobalMethod() {
        val plugin = HaishinKitPlugin()
        val result = Mockito.mock(MethodChannel.Result::class.java)
        plugin.onMethodCall(MethodCall("getPlatformVersion", mapOf("memory" to -1)), result)
        Mockito.verify(result).notImplemented()
        Mockito.verifyNoMoreInteractions(result)
    }
}
