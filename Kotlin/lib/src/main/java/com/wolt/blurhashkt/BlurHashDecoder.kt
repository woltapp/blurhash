package com.wolt.blurhashkt

import android.graphics.Bitmap
import android.graphics.Color
import kotlin.math.PI
import kotlin.math.cos
import kotlin.math.pow
import kotlin.math.withSign

object BlurHashDecoder {

    /**
     * Decode a blur hash into a new bitmap.
     */
    fun decode(blurHash: String?, width: Int, height: Int, punch: Float = 1f): Bitmap? {
        if (blurHash == null || blurHash.length < 6) {
            return null
        }
        val numCompEnc = decode83(blurHash, 0, 1)
        val numCompX = (numCompEnc % 9) + 1
        val numCompY = (numCompEnc / 9) + 1
        val totalComp = numCompX * numCompY
        if (blurHash.length != 4 + 2 * totalComp) {
            return null
        }
        val maxAcEnc = decode83(blurHash, 1, 2)
        val maxAc = (maxAcEnc + 1) / 166f
        val colors = FloatArray(totalComp * 3)
        var colorEnc = decode83(blurHash, 2, 6)
        decodeDc(colorEnc, colors)
        for (i in 1 until totalComp) {
            val from = 4 + i * 2
            colorEnc = decode83(blurHash, from, from + 2)
            decodeAc(colorEnc, maxAc * punch, colors, i * 3)
        }
        return composeBitmap(width, height, numCompX, numCompY, colors)
    }

    private fun decode83(str: String, from: Int, to: Int): Int {
        var result = 0
        for (i in from until to) {
            val index = CHARS.indexOf(str[i])
            if (index != -1) {
                result = result * 83 + index
            }
        }
        return result
    }

    private fun decodeDc(colorEnc: Int, outArray: FloatArray) {
        val r = (colorEnc shr 16) and 0xFF
        val g = (colorEnc shr 8) and 0xFF
        val b = colorEnc and 0xFF
        outArray[0] = srgbToLinear(r)
        outArray[1] = srgbToLinear(g)
        outArray[2] = srgbToLinear(b)
    }

    private fun srgbToLinear(colorEnc: Int): Float {
        val v = colorEnc / 255f
        return if (v <= 0.04045f) {
            (v / 12.92f)
        } else {
            ((v + 0.055f) / 1.055f).pow(2.4f)
        }
    }

    private fun decodeAc(value: Int, maxAc: Float, outArray: FloatArray, outIndex: Int) {
        val r = value / (19 * 19)
        val g = (value / 19) % 19
        val b = value % 19
        outArray[outIndex] = signedPow2((r - 9) / 9.0f) * maxAc
        outArray[outIndex + 1] = signedPow2((g - 9) / 9.0f) * maxAc
        outArray[outIndex + 2] = signedPow2((b - 9) / 9.0f) * maxAc
    }

    private fun signedPow2(value: Float) = (value * value).withSign(value)

    private fun composeBitmap(
        width: Int, height: Int,
        numCompX: Int, numCompY: Int,
        colors: FloatArray
    ): Bitmap {
        // use an array for better performance when writing pixel colors
        val imageArray = IntArray(width * height)
        val cosinesX = createCosines(width, numCompX)
        val cosinesY = if (width == height && numCompX == numCompY) {
            cosinesX
        } else {
            createCosines(height, numCompY)
        }
        for (y in 0 until height) {
            for (x in 0 until width) {
                var r = 0f
                var g = 0f
                var b = 0f
                for (j in 0 until numCompY) {
                    val cosY = cosinesY[y * numCompY + j]
                    for (i in 0 until numCompX) {
                        val cosX = cosinesX[x * numCompX + i]
                        val basis = cosX * cosY
                        val colorIndex = (j * numCompX + i) * 3
                        r += colors[colorIndex] * basis
                        g += colors[colorIndex + 1] * basis
                        b += colors[colorIndex + 2] * basis
                    }
                }
                imageArray[x + width * y] =
                    Color.rgb(linearToSrgb(r), linearToSrgb(g), linearToSrgb(b))
            }
        }
        return Bitmap.createBitmap(imageArray, width, height, Bitmap.Config.ARGB_8888)
    }

    private fun createCosines(size: Int, numComp: Int) = FloatArray(size * numComp) { index ->
        val x = index / numComp
        val i = index % numComp
        cos(PI * x * i / size).toFloat()
    }

    private fun linearToSrgb(value: Float): Int {
        val v = value.coerceIn(0f, 1f)
        return if (v <= 0.0031308f) {
            (v * 12.92f * 255f + 0.5f).toInt()
        } else {
            ((1.055f * v.pow(1 / 2.4f) - 0.055f) * 255 + 0.5f).toInt()
        }
    }

    private const val CHARS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz#$%*+,-.:;=?@[]^_{|}~"
}
