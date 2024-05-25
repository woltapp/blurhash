package com.wolt.blurhashkt

import android.graphics.Bitmap
import com.wolt.blurhashkt.BlurHashDecoder.clearCache
import com.wolt.blurhashkt.BlurHashDecoder.decode
import junit.framework.Assert.assertTrue
import org.junit.Before
import org.junit.Test
import java.nio.ByteBuffer
import java.util.*


class BlurHashDecoderTest {
    @Before
    @Throws(Exception::class)
    fun setUp() {
        clearCache()
    }

    @Test
    fun decode_smallImage_cacheEnabled_shouldGetTheSameBitmapInManyRequests() {
        val bmp1 = decode("LEHV6nWB2yk8pyo0adR*.7kCMdnj", 20, 12)!!
        val bmp2 = decode("LEHV6nWB2yk8pyo0adR*.7kCMdnj", 20, 12)!!
        val bmp3 = decode("LEHV6nWB2yk8pyo0adR*.7kCMdnj", 20, 12)!!

        bmp1.assertEquals(bmp2)
        bmp2.assertEquals(bmp3)
    }

    @Test
    fun decode_smallImage_differentCache_shouldGetTheSameBitmapInManyRequests() {
        val bmp1 = decode("LEHV6nWB2yk8pyo0adR*.7kCMdnj", 20, 12)!!
        val bmp2 = decode("LEHV6nWB2yk8pyo0adR*.7kCMdnj", 20, 12, useCache = false)!!
        val bmp3 = decode("LEHV6nWB2yk8pyo0adR*.7kCMdnj", 20, 12)!!

        bmp1.assertEquals(bmp2)
        bmp2.assertEquals(bmp3)
    }

    @Test
    fun decode_smallImage_cacheDisabled_shouldGetTheSameBitmapInManyRequests() {
        val bmp1 = decode("LEHV6nWB2yk8pyo0adR*.7kCMdnj", 20, 12, useCache = false)!!
        val bmp2 = decode("LEHV6nWB2yk8pyo0adR*.7kCMdnj", 20, 12, useCache = false)!!
        val bmp3 = decode("LEHV6nWB2yk8pyo0adR*.7kCMdnj", 20, 12, useCache = false)!!

        bmp1.assertEquals(bmp2)
        bmp2.assertEquals(bmp3)
    }

    @Test
    fun decode_bigImage_cacheEnabled_shouldGetTheSameBitmapInManyRequests() {
        val bmp1 = decode("LEHV6nWB2yk8pyo0adR*.7kCMdnj", 100, 100)!!
        val bmp2 = decode("LEHV6nWB2yk8pyo0adR*.7kCMdnj", 100, 100)!!
        val bmp3 = decode("LEHV6nWB2yk8pyo0adR*.7kCMdnj", 100, 100)!!

        bmp1.assertEquals(bmp2)
        bmp2.assertEquals(bmp3)
    }

    @Test
    fun decode_bigImage_differentCache_shouldGetTheSameBitmapInManyRequests() {
        val bmp1 = decode("LEHV6nWB2yk8pyo0adR*.7kCMdnj", 100, 100)!!
        val bmp2 = decode("LEHV6nWB2yk8pyo0adR*.7kCMdnj", 100, 100, useCache = false)!!
        val bmp3 = decode("LEHV6nWB2yk8pyo0adR*.7kCMdnj", 100, 100)!!

        bmp1.assertEquals(bmp2)
        bmp2.assertEquals(bmp3)
    }

    @Test
    fun decode_bigImage_cacheDisabled_shouldGetTheSameBitmapInManyRequests() {
        val bmp1 = decode("LEHV6nWB2yk8pyo0adR*.7kCMdnj", 100, 100, useCache = false)!!
        val bmp2 = decode("LEHV6nWB2yk8pyo0adR*.7kCMdnj", 100, 100, useCache = false)!!
        val bmp3 = decode("LEHV6nWB2yk8pyo0adR*.7kCMdnj", 100, 100, useCache = false)!!

        bmp1.assertEquals(bmp2)
        bmp2.assertEquals(bmp3)
    }
}

fun Bitmap.assertEquals(bitmap2: Bitmap) {
    val buffer1: ByteBuffer = ByteBuffer.allocate(height * rowBytes)
    copyPixelsToBuffer(buffer1)
    val buffer2: ByteBuffer = ByteBuffer.allocate(bitmap2.height * bitmap2.rowBytes)
    bitmap2.copyPixelsToBuffer(buffer2)
    val equals = Arrays.equals(buffer1.array(), buffer2.array())
    assertTrue(equals)
}
