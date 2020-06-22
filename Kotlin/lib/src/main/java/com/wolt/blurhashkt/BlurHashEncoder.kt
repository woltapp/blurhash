package com.wolt.blurhashkt

import android.graphics.Bitmap
import com.wolt.blurhashkt.Base83.encode
import com.wolt.blurhashkt.Utils.linearToSrgb
import com.wolt.blurhashkt.Utils.signedPow
import com.wolt.blurhashkt.Utils.srgbToLinear
import kotlin.math.*

object BlurHashEncoder {

    private fun applyBasisFunction(pixels: IntArray, width: Int, height: Int,
                                   normalisation: Float, i: Int, j: Int, factors: Array<FloatArray>,
                                   index: Int) {
        var r = 0f
        var g = 0f
        var b = 0f
        for (x in 0 until width) for (y in 0 until height) {
            val basis = (normalisation * cos(PI * i * x / width) *
                    cos(PI * j * y / height)).toFloat()
            val pixel = pixels[y * width + x]
            r += basis * srgbToLinear((pixel shr 16) and 255)
            g += basis * srgbToLinear((pixel shr 8) and 255)
            b += basis * srgbToLinear(pixel and 255)
        }
        val scale = 1f / (width * height)
        factors[index][0] = r * scale
        factors[index][1] = g * scale
        factors[index][2] = b * scale
    }

    private fun encodeDC(value: FloatArray): Int {
        val r: Int = linearToSrgb(value[0])
        val g: Int = linearToSrgb(value[1])
        val b: Int = linearToSrgb(value[2])
        return (r shl 16) + (g shl 8) + b
    }

    private fun encodeAC(value: FloatArray, maximumValue: Float): Int {
        val quantR = floor(max(0f,
                min(18f, floor(signedPow(value[0] / maximumValue, 0.5f) * 9 + 9.5f))))
        val quantG = floor(max(0f,
                min(18f, floor(signedPow(value[1] / maximumValue, 0.5f) * 9 + 9.5f))))
        val quantB = floor(max(0f,
                min(18f, floor(signedPow(value[2] / maximumValue, 0.5f) * 9 + 9.5f))))
        return round(quantR * 19 * 19 + quantG * 19 + quantB).toInt()
    }

    /**
     * Calculates the blur hash from the given image with 4x4 components.
     *
     * @param bitmap the image
     * @return the blur hash
     */
    fun encode(bitmap: Bitmap): String {
        return encode(bitmap, 4, 4)
    }

    /**
     * Calculates the blur hash from the given image.
     *
     * @param bitmap     the image
     * @param componentX number of components in the x dimension
     * @param componentY number of components in the y dimension
     * @return the blur hash
     */
    fun encode(bitmap: Bitmap, componentX: Int, componentY: Int): String {
        val width = bitmap.width
        val height = bitmap.height
        val pixels = IntArray(width * height)
        bitmap.getPixels(pixels, 0, width, 0, 0, width, height)
        return encode(pixels, width, height, componentX, componentY)
    }

    /**
     * Calculates the blur hash from the given pixels.
     *
     * @param pixels     width * height pixels, encoded as RGB integers (0xAARRGGBB)
     * @param width      width of the bitmap
     * @param height     height of the bitmap
     * @param componentX number of components in the x dimension
     * @param componentY number of components in the y dimension
     * @return the blur hash
     */
    private fun encode(pixels: IntArray, width: Int, height: Int, componentX: Int,
                       componentY: Int): String {
        require(!(componentX < 1 || componentX > 9 || componentY < 1 || componentY > 9)) { "Blur hash must have between 1 and 9 components" }
        require(width * height == pixels.size) { "Width and height must match the pixels array" }
        val factors = Array(componentX * componentY) { FloatArray(3) }
        for (j in 0 until componentY) {
            for (i in 0 until componentX) {
                val normalisation = if (i == 0 && j == 0) 1f else 2f
                applyBasisFunction(pixels, width, height, normalisation, i, j, factors,
                        j * componentX + i)
            }
        }
        val hash = CharArray(1 + 1 + 4 + 2 * (factors.size - 1)) // size flag + max AC + DC + 2 * AC components
        val sizeFlag = componentX - 1 + (componentY - 1) * 9
        encode(sizeFlag, 1, hash, 0)
        val maximumValue: Float
        if (factors.size > 1) {
            val actualMaximumValue = Utils.max(factors, 1, factors.size)
            val quantisedMaximumValue = floor(
                    max(0f, min(82f, floor(actualMaximumValue * 166 - 0.5f))))
            maximumValue = (quantisedMaximumValue + 1) / 166
            encode(round(quantisedMaximumValue).toInt(), 1, hash, 1)
        } else {
            maximumValue = 1f
            encode(0, 1, hash, 1)
        }
        val dc = factors[0]
        encode(encodeDC(dc), 4, hash, 2)
        for (i in 1 until factors.size) {
            encode(encodeAC(factors[i], maximumValue), 2, hash, 6 + 2 * (i - 1))
        }
        return String(hash)
    }

}