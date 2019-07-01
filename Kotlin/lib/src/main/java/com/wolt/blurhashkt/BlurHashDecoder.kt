package com.wolt.blurhashkt

import android.graphics.Bitmap
import android.graphics.Color
import kotlin.math.*

/**
 * Created by mike on 31/07/2017.
 */
object BlurHashDecoder {

    private val digitCharacters = arrayOf(
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
        'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
        'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd',
        'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
        'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x',
        'y', 'z', '#', '$', '%', '*', '+', ',', '-', '.',
        ':', ';', '=', '?', '@', '[', ']', '^', '_', '{',
        '|', '}', '~'
    )

    fun decode(blurHash: String?, width: Int, height: Int, punch: Float): Bitmap? {
        if (blurHash == null || blurHash.length < 6) {
            return null
        }

        val sizeFlag = blurHash[0].toString().decode83()
        val numY = (sizeFlag / 9) + 1
        val numX = (sizeFlag % 9) + 1

        if (blurHash.length != 4 + 2 * numX * numY) {
            return null
        }

        val quantisedMaximumValue = blurHash[1].toString().decode83()
        val maximumValue = (quantisedMaximumValue + 1) / 166f

        val colors = (0 until numX * numY).map { i ->
            if (i == 0) {
                val value = blurHash.substring(2, 6).decode83()
                decodeDc(value)
            } else {
                val startIndex = 4 + i * 2
                val value = blurHash.substring(startIndex, startIndex + 2).decode83()
                decodeAc(value, maximumValue * punch)
            }
        }

        val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)

        for (y in 0 until height) {
            for (x in 0 until width) {
                var r = 0f
                var g = 0f
                var b = 0f

                for (j in 0 until numY) {
                    for (i in 0 until numX) {
                        val basis = (cos(PI * x * i / width) * cos(PI * y * j / height)).toFloat()
                        val color = colors[i + j * numX]
                        r += color[0] * basis
                        g += color[1] * basis
                        b += color[2] * basis
                    }
                }

                bitmap.setPixel(x, y, Color.rgb(linearToSRgb(r), linearToSRgb(g), linearToSRgb(b)))
            }
        }

        return bitmap
    }

    private fun String.decode83(): Int {
        var value = 0
        for (i in 0 until this.length) {
            val digit = digitCharacters.indexOf(this[i])
            if (digit != -1) {
                value = value * 83 + digit
            }
        }
        return value
    }

    private fun decodeDc(value: Int): Array<Float> {
        val intR = value shr 16
        val intG = (value shr 8) and 255
        val intB = value and 255
        return arrayOf(sRgbToLinear(intR), sRgbToLinear(intG), sRgbToLinear(intB))
    }

    private fun sRgbToLinear(value: Int): Float {
        val v = value / 255f
        return if (v <= 0.04045) (v / 12.92f) else ((v + 0.055) / 1.055).pow(2.4).toFloat()
    }

    private fun decodeAc(value: Int, maximumValue: Float): Array<Float> {
        val quantR = value / (19 * 19)
        val quantG = (value / 19) % 19
        val quantB = value % 19
        return arrayOf(
                signPow((quantR - 9) / 9.0f, 2.0f) * maximumValue,
                signPow((quantG - 9) / 9.0f, 2.0f) * maximumValue,
                signPow((quantB - 9) / 9.0f, 2.0f) * maximumValue
        )
    }

    private fun signPow(value: Float, exp: Float) = value.pow(exp).withSign(value)

    private fun linearToSRgb(value: Float): Int {
        val v = value.coerceIn(0f, 1f)
        return if (v <= 0.0031308f) {
            (v * 12.92f * 255 + 0.5f).toInt()
        } else {
            ((1.055f * v.toDouble().pow( 1 / 2.4) - 0.055f) * 255 + 0.5f).toInt()
        }
    }

}
