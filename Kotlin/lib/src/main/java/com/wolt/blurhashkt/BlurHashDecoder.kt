package com.wolt.blurhashkt

import android.graphics.Bitmap
import android.graphics.Color
import java.util.*
import kotlin.math.cos
import kotlin.math.pow
import kotlin.math.withSign

// this is to optimize the number of calculations for "Math.cos()",
// is is slow and for many images with same size it can be cached, improving performance.
// the improvement can be noticed with images bigger than 80x80
private const val USE_CACHE_FOR_MATH_COS = true

object BlurHashDecoder {

    private val cacheCosinesX = HashMap<Int, DoubleArray>()
    private val cacheCosinesY = HashMap<Int, DoubleArray>()

    fun decode(blurHash: String?, width: Int, height: Int, punch: Float = 1f): Bitmap? {
        if (blurHash == null || blurHash.length < 6) {
            return null
        }
        val numCompEnc = decode83(blurHash, 0, 1)
        val numCompX = (numCompEnc % 9) + 1
        val numCompY = (numCompEnc / 9) + 1
        if (blurHash.length != 4 + 2 * numCompX * numCompY) {
            return null
        }
        val maxAcEnc = decode83(blurHash, 1, 2)
        val maxAc = (maxAcEnc + 1) / 166f
        val colors = Array(numCompX * numCompY) { i ->
            if (i == 0) {
                val colorEnc = decode83(blurHash, 2, 6)
                decodeDc(colorEnc)
            } else {
                val from = 4 + i * 2
                val colorEnc = decode83(blurHash, from, from + 2)
                decodeAc(colorEnc, maxAc * punch)
            }
        }
        return composeBitmap(width, height, numCompX, numCompY, colors)
    }

    private fun decode83(str: String, from: Int = 0, to: Int = str.length): Int {
        var result = 0
        for (i in from until to) {
            val index = charMap[str[i]] ?: -1
            if (index != -1) {
                result = result * 83 + index
            }
        }
        return result
    }

    private fun decodeDc(colorEnc: Int): FloatArray {
        val r = colorEnc shr 16
        val g = (colorEnc shr 8) and 255
        val b = colorEnc and 255
        return floatArrayOf(srgbToLinear(r), srgbToLinear(g), srgbToLinear(b))
    }

    private fun srgbToLinear(colorEnc: Int): Float {
        val v = colorEnc / 255f
        return if (v <= 0.04045f) {
            (v / 12.92f)
        } else {
            ((v + 0.055f) / 1.055f).pow(2.4f)
        }
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

    private fun signedPow2(value: Float) = value.pow(2f).withSign(value)

    private fun composeBitmap(
            width: Int, height: Int,
            numCompX: Int, numCompY: Int,
            colors: Array<FloatArray>
    ): Bitmap {
        // use an array for better performance when writing pixel colors
        val imageArray = IntArray(width * height)
        val calculateCosX = !USE_CACHE_FOR_MATH_COS || !cacheCosinesX.containsKey(width * numCompX)
        val cosinesX = getCosinesX(calculateCosX, width, numCompX)
        val calculateCosY = !USE_CACHE_FOR_MATH_COS || !cacheCosinesY.containsKey(height * numCompY)
        val cosinesY = getCosinesY(calculateCosY, height, numCompY)
        for (y in 0 until height) {
            for (x in 0 until width) {
                var r = 0f
                var g = 0f
                var b = 0f
                for (j in 0 until numCompY) {
                    for (i in 0 until numCompX) {
                        val cosX = getCosX(calculateCosX, cosinesX, i, numCompX, x, width)
                        val cosY = getCosY(calculateCosY, cosinesY, j, numCompY, y, height)
                        val basis = (cosX * cosY).toFloat()
                        val color = colors[j * numCompX + i]
                        r += color[0] * basis
                        g += color[1] * basis
                        b += color[2] * basis
                    }
                }
                imageArray[x + width * y] = Color.rgb(linearToSrgb(r), linearToSrgb(g), linearToSrgb(b))
            }
        }
        return Bitmap.createBitmap(imageArray, width, height, Bitmap.Config.ARGB_8888)
    }

    private fun getCosinesY(calculateCosY: Boolean, height: Int, numCompY: Int): DoubleArray {
        val cosinesY: DoubleArray
        if (calculateCosY) {
            cosinesY = DoubleArray(height * numCompY)
            cacheCosinesY[height * numCompY] = cosinesY
        } else {
            cosinesY = cacheCosinesY[height * numCompY]!!
        }
        return cosinesY
    }

    private fun getCosY(
            calculateCosY: Boolean,
            cosinesY: DoubleArray,
            j: Int,
            numCompY: Int,
            y: Int,
            height: Int
    ): Double {
        if (calculateCosY) {
            cosinesY[j + numCompY * y] = cos(Math.PI * y * j / height)
        }
        return cosinesY[j + numCompY * y]
    }

    private fun getCosX(
            calculateCosX: Boolean,
            cosinesX: DoubleArray,
            i: Int,
            numCompX: Int,
            x: Int,
            width: Int
    ): Double {
        if (calculateCosX) {
            cosinesX[i + numCompX * x] = cos(Math.PI * x * i / width)
        }
        return cosinesX[i + numCompX * x]
    }

    private fun getCosinesX(calculateCosX: Boolean, width: Int, numCompX: Int): DoubleArray {
        return when {
            calculateCosX -> {
                DoubleArray(width * numCompX).also {
                    cacheCosinesX[width * numCompX] = it
                }
            }
            else -> cacheCosinesX[width * numCompX]!!
        }
    }

    private fun linearToSrgb(value: Float): Int {
        val v = value.coerceIn(0f, 1f)
        return if (v <= 0.0031308f) {
            (v * 12.92f * 255f + 0.5f).toInt()
        } else {
            ((1.055f * v.pow(1 / 2.4f) - 0.055f) * 255 + 0.5f).toInt()
        }
    }

    private val charMap = listOf(
            '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G',
            'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
            'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
            'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '#', '$', '%', '*', '+', ',',
            '-', '.', ':', ';', '=', '?', '@', '[', ']', '^', '_', '{', '|', '}', '~'
    )
            .mapIndexed { i, c -> c to i }
            .toMap()

}
