package com.wolt.blurhashkt

import android.graphics.Bitmap
import java.lang.Math.*
import java.nio.IntBuffer
import kotlin.math.PI
import kotlin.math.pow

object BlurHashEncoder {

    fun blurHash(bitmap: Bitmap, components: Pair<Int, Int>): String? {
        if (components.first !in 1..9 || components.second !in 1..9) {
            return null
        }


        val width = bitmap.width
        val height = bitmap.height
        val bytesPerRow = bitmap.rowBytes
        var pixels: IntArray? = null
        bitmap.getPixels(pixels, 0, bitmap.width, 0, 0, bitmap.width, bitmap.height)

        if (pixels == null) {
            return null
        }

        val factors: MutableList<Array<Float>> = mutableListOf()
        for (y in 0 until components.second) {
            for (x in 0 until components.first) {
                val normalisation: Float = if (x == 0 && y == 0) 1f else 2f
                val factor =
                    multiplyBasisFunction(pixels, width, height, bytesPerRow, 4, 0) { a, b ->
                        (normalisation * kotlin.math.cos(PI * x * a / width) * kotlin.math.cos(PI * y * b / height)).toFloat()
                    }
                factors.add(factor)
            }
        }

        val dc = factors.removeAt(0)
        val ac = factors

        var hash = ""

        val sizeFlag = (components.first - 1) + (components.second - 1) * 9
        hash += sizeFlag.encode83(1)

        val maximumValue: Float
        if (ac.size > 0) {
            val actualMaximumValue = ac.map { it.maxOrNull() }.maxByOrNull { it!! }!!
            val quantisedMaximumValue =
                0.0.coerceAtLeast(82.0.coerceAtMost(kotlin.math.floor(actualMaximumValue * 166 - 0.5)))
                    .toInt()
            maximumValue = (quantisedMaximumValue + 1) / 166.0f
            hash += quantisedMaximumValue.encode83(1)
        } else {
            maximumValue = 1f
            hash += 0.encode83(1)
        }

        hash += encodeDC(dc).encode83(4)

        for (factor in ac) {
            hash += encodeAC(factor, maximumValue).encode83(2)
        }

        return hash
    }

    private fun multiplyBasisFunction(
        pixels: IntArray,
        width: Int,
        height: Int,
        bytesPerRow: Int,
        bytesPerPixel: Int,
        pixelOffset: Int,
        basisFunction: (Float, Float) -> Float
    ): Array<Float> {
        var r = 0f
        var g = 0f
        var b = 0f

        val buffer = IntBuffer.wrap(pixels, pixels.size, height * bytesPerRow)

        for (x in 0 until width) {
            for (y in 0 until height) {
                val basis = basisFunction(x.toFloat(), y.toFloat())
                r += basis * sRgbToLinear(buffer[bytesPerPixel * x + pixelOffset + 0 + y * bytesPerRow])
                g += basis * sRgbToLinear(buffer[bytesPerPixel * x + pixelOffset + 1 + y * bytesPerRow])
                b += basis * sRgbToLinear(buffer[bytesPerPixel * x + pixelOffset + 2 + y * bytesPerRow])
            }
        }

        val scale = 1 / (width * height).toFloat()

        return arrayOf(r * scale, g * scale, b * scale)
    }


    private val encodeCharacters: List<String> =
        "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz#$%*+,-.:;=?@[]^_{|}~".map { it.toString() }

    private fun encodeDC(value: Array<Float>): Int {
        val roundedR = linearToSRgb(value[0])
        val roundedG = linearToSRgb(value[1])
        val roundedB = linearToSRgb(value[2])
        return (roundedR shl 16) + (roundedG shl 8) + roundedB
    }

    private fun encodeAC(value: Array<Float>, maximumValue: Float): Int {
        0.0.coerceAtLeast(
            18.0.coerceAtMost(
                kotlin.math.floor(
                    (value[0] / maximumValue.toDouble()).pow(0.5) * 9 + 9.5
                )
            )
        )
        val quantR = 0.0.coerceAtLeast(
            18.0.coerceAtMost(
                kotlin.math.floor(
                    (value[0] / maximumValue.toDouble()).pow(0.5) * 9 + 9.5
                )
            )
        ).toInt()
        val quantG = 0.0.coerceAtLeast(
            18.0.coerceAtMost(
                kotlin.math.floor(
                    (value[1] / maximumValue.toDouble()).pow(0.5) * 9 + 9.5
                )
            )
        ).toInt()
        val quantB = 0.0.coerceAtLeast(
            18.0.coerceAtMost(
                kotlin.math.floor(
                    (value[2] / maximumValue.toDouble()).pow(0.5) * 9 + 9.5
                )
            )
        ).toInt()

        return quantR * 19 * 19 + quantG * 19 + quantB
    }

    private fun sRgbToLinear(value: Int): Float {
        val v = value / 255f
        return if (v <= 0.04045) (v / 12.92f) else (pow((v + 0.055) / 1.055, 2.4).toFloat())
    }

    private fun linearToSRgb(value: Float): Int {
        val v = 0f.coerceAtLeast(1f.coerceAtMost(value))
        return if (v <= 0.0031308f) {
            (v * 12.92f * 255 + 0.5f).toInt()
        } else {
            ((1.055f * v.toDouble().pow(1 / 2.4) - 0.055f) * 255 + 0.5f).toInt()
        }
    }


    private fun Int.encode83(length: Int): String {
        var result = ""
        for (i in 1..length) {
            val digit = (this / myPow(83, (length - i))) % 83
            result += encodeCharacters[digit]
        }
        return result
    }

    private fun myPow(base: Int, exponent: Int): Int {
        return (0 until exponent).fold(1) { acc, _ -> acc * base }
    }
}
