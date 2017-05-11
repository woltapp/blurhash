import Foundation

let digitCharacters = [
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
    "k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
    "u", "v", "w", "x", "y", "z", "A", "B", "C", "D",
    "E", "F", "G", "H", "I", "J", "K", "L", "M", "N",
    "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X",
    "Y", "Z", ":", ";"
]

extension Int {
    func encode64(length: Int) -> String {
        var result = ""
        for i in 1 ... length {
            let digit = (self >> (6 * (length - i))) & 63
            result += digitCharacters[digit]
        }
        return result
    }
}

extension String {
    func decode64() -> Int {
        var value: Int = 0
        for character in characters {
            if let digit = digitCharacters.index(of: String(character)) {
                value = (value << 6) + digit
            }
        }
        return value
    }
}
