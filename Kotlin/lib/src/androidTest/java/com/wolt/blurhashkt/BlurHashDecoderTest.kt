package com.wolt.blurhashkt

import android.graphics.Bitmap
import com.wolt.blurhashkt.BlurHashDecoder.decode
import org.junit.Assert.assertArrayEquals
import org.junit.Test
import java.nio.ByteBuffer


class BlurHashDecoderTest {
    @Test
    fun decode_smallImage_shouldGetTheSameBitmapInManyRequests() {
        val bmp1 = decode("LEHV6nWB2yk8pyo0adR*.7kCMdnj", 20, 12)!!
        val bmp2 = decode("LEHV6nWB2yk8pyo0adR*.7kCMdnj", 20, 12)!!
        val bmp3 = decode("LEHV6nWB2yk8pyo0adR*.7kCMdnj", 20, 12)!!

        bmp1.assertEquals(bmp2)
        bmp2.assertEquals(bmp3)
    }

    @Test
    fun decode_bigImage_shouldGetTheSameBitmapInManyRequests() {
        val bmp1 = decode("LEHV6nWB2yk8pyo0adR*.7kCMdnj", 100, 100)!!
        val bmp2 = decode("LEHV6nWB2yk8pyo0adR*.7kCMdnj", 100, 100)!!
        val bmp3 = decode("LEHV6nWB2yk8pyo0adR*.7kCMdnj", 100, 100)!!

        bmp1.assertEquals(bmp2)
        bmp2.assertEquals(bmp3)
    }
}

fun Bitmap.assertEquals(bitmap2: Bitmap) {
    val buffer1: ByteBuffer = ByteBuffer.allocate(height * rowBytes)
    copyPixelsToBuffer(buffer1)
    val buffer2: ByteBuffer = ByteBuffer.allocate(bitmap2.height * bitmap2.rowBytes)
    bitmap2.copyPixelsToBuffer(buffer2)
    assertArrayEquals(buffer1.array(), buffer2.array())
}
