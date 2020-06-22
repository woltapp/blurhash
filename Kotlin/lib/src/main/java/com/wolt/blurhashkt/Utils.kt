package com.wolt.blurhashkt

import kotlin.math.abs
import kotlin.math.pow
import kotlin.math.withSign

internal object Utils {

    internal fun linearToSrgb(value: Float): Int {
        val v = value.coerceIn(0f, 1f)
        return if (v <= 0.0031308f) {
            (v * 12.92f * 255f + 0.5f).toInt()
        } else {
            ((1.055f * v.pow(1 / 2.4f) - 0.055f) * 255 + 0.5f).toInt()
        }
    }

    internal fun srgbToLinear(colorEnc: Int): Float {
        val v = colorEnc / 255f
        return if (v <= 0.04045f) {
            (v / 12.92f)
        } else {
            ((v + 0.055f) / 1.055f).pow(2.4f)
        }
    }

    internal fun signedPow2(value: Float) = value.pow(2f).withSign(value)

    internal fun signedPow(value: Float, exp: Float) = abs(value).pow(exp).withSign(value)

    internal fun max(values: Array<FloatArray>, from: Int, endExclusive: Int): Float {
        var result = Float.NEGATIVE_INFINITY
        for (i in from until endExclusive) {
            for (value in values[i]) {
                if (value > result) {
                    result = value
                }
            }
        }
        return result
    }

}