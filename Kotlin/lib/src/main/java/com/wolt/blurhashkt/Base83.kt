package com.wolt.blurhashkt

internal object Base83 {

    private val CHAR_MAP = listOf(
            '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G',
            'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
            'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
            'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '#', '$', '%', '*', '+', ',',
            '-', '.', ':', ';', '=', '?', '@', '[', ']', '^', '_', '{', '|', '}', '~'
    )

	fun encode(value: Int, length: Int, buffer: CharArray, offset: Int) {
        var exp = 1
        var i = 1
        while (i <= length) {
            val digit = (value / exp % 83).toInt()
            buffer[offset + length - i] = CHAR_MAP[digit]
            i++
            exp *= 83
        }
    }

    fun decode(str: String, from: Int = 0, to: Int = str.length): Int {
        var result = 0
        for (i in from until to) {
            val index = CHAR_MAP.indexOf(str[i])
            if (index != -1) {
                result = result * 83 + index
            }
        }
        return result
    }
}