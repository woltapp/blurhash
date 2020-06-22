package com.wolt.blurhashkt

import android.graphics.Bitmap
import android.graphics.Color
import com.wolt.blurhashkt.Utils.linearToSrgb
import com.wolt.blurhashkt.Utils.signedPow2
import com.wolt.blurhashkt.Utils.srgbToLinear
import kotlin.math.PI
import kotlin.math.cos

object BlurHashDecoder {

    fun decode(blurHash: String?, width: Int, height: Int, punch: Float = 1f): Bitmap? {
        if (blurHash == null || blurHash.length < 6) {
            return null
        }
        val numCompEnc = Base83.decode(blurHash, 0, 1)
        val numCompX = (numCompEnc % 9) + 1
        val numCompY = (numCompEnc / 9) + 1
        if (blurHash.length != 4 + 2 * numCompX * numCompY) {
            return null
        }
        val maxAcEnc = Base83.decode(blurHash, 1, 2)
        val maxAc = (maxAcEnc + 1) / 166f
        val colors = Array(numCompX * numCompY) { i ->
            if (i == 0) {
                val colorEnc = Base83.decode(blurHash, 2, 6)
                decodeDc(colorEnc)
            } else {
                val from = 4 + i * 2
                val colorEnc = Base83.decode(blurHash, from, from + 2)
                decodeAc(colorEnc, maxAc * punch)
            }
        }
        return composeBitmap(width, height, numCompX, numCompY, colors)
    }

    private fun decodeDc(colorEnc: Int): FloatArray {
        val r = colorEnc shr 16
        val g = (colorEnc shr 8) and 255
        val b = colorEnc and 255
        return floatArrayOf(srgbToLinear(r), srgbToLinear(g), srgbToLinear(b))
    }

    private fun decodeAc(value: Int, maxAc: Float): FloatArray {
        val r = value / (19 * 19)
        val g = (value / 19) % 19
        val b = value % 19
        return floatArrayOf(
                signedPow2((r - 9) / 9.0f) * maxAc,
                signedPow2((g - 9) / 9.0f) * maxAc,
                signedPow2((b - 9) / 9.0f) * maxAc
        )
    }

    private fun composeBitmap(
            width: Int, height: Int,
            numCompX: Int, numCompY: Int,
            colors: Array<FloatArray>
    ): Bitmap {
        val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
        for (y in 0 until height) {
            for (x in 0 until width) {
                var r = 0f
                var g = 0f
                var b = 0f
                for (j in 0 until numCompY) {
                    for (i in 0 until numCompX) {
                        val basis = (cos(PI * x * i / width) * cos(PI * y * j / height)).toFloat()
                        val color = colors[j * numCompX + i]
                        r += color[0] * basis
                        g += color[1] * basis
                        b += color[2] * basis
                    }
                }
                bitmap.setPixel(x, y, Color.rgb(linearToSrgb(r), linearToSrgb(g), linearToSrgb(b)))
            }
        }
        return bitmap
    }

}
