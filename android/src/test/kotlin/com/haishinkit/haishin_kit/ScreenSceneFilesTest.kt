package com.haishinkit.haishin_kit

import android.content.Context
import com.haishinkit.screen.EdgeInsets
import com.haishinkit.screen.scene.SceneFile
import com.haishinkit.screen.scene.ScreenObjectSnapshot
import org.mockito.Mockito
import java.nio.file.Files
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertTrue

internal class ScreenSceneFilesTest {
    private fun root(): ScreenObjectSnapshot {
        val title = ScreenObjectSnapshot(
            type = "text", id = "title", size = ScreenObjectSnapshot.Size(0, 0),
            isVisible = true, layoutMargin = EdgeInsets(0, 0, 0, 0),
            horizontalAlignment = 0, verticalAlignment = 0,
            elements = mapOf("value" to "HaishinKit"), children = emptyList(),
        )
        return title.copy(type = "screen", id = "root", size = ScreenObjectSnapshot.Size(1280, 720), elements = emptyMap(), children = listOf(title))
    }

    @Test
    fun nativeSceneRoundTripPreservesCompositionAndOpaqueResources() {
        val cache = Files.createTempDirectory("flutter-scene-test").toFile()
        val context = Mockito.mock(Context::class.java)
        Mockito.`when`(context.cacheDir).thenReturn(cache)
        val files = ScreenSceneFiles(context)
        try {
            val original = SceneFile(root(), mapOf("future.bin" to byteArrayOf(1, 2, 3)))
            val loaded = files.prepare(original.write())
            files.install(loaded)
            val exported = SceneFile.read(files.encode(loaded.snapshot))
            assertEquals(original.snapshot, exported.snapshot)
            assertTrue(exported.resources.getValue("future.bin").contentEquals(byteArrayOf(1, 2, 3)))
            val duplicate = root().copy(children = root().children + root().children)
            assertFailsWith<IllegalArgumentException> { files.prepare(SceneFile(duplicate).write()) }
            assertFailsWith<IllegalArgumentException> {
                files.prepare(SceneFile(root().copy(size = ScreenObjectSnapshot.Size(8192, 8192))).write())
            }
            assertEquals(1, cache.walkTopDown().count { it.name.startsWith("import-") })
        } finally { files.close(); cache.deleteRecursively() }
    }
}
