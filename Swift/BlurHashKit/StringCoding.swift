import Foundation

private let encodeCharacters: [String] = {
    return "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz#$%*+,-.:;=?@[]^_{|}~".map { String($0) }
}()

private let decodeCharacters: [String: Int] = {
	var dict: [String: Int] = [:]
	for (index, character) in encodeCharacters.enumerated() {
		dict[character] = index
	}
	return dict
}()

extension BinaryInteger {
	func encode83(length: Int) -> String {
		var result = ""
		for i in 1 ... length {
			let digit = (Int(self) / pow(83, length - i)) % 83
			result += encodeCharacters[Int(digit)]
		}
		return result
	}
}

extension String {
	func decode83() -> Int {
		var value: Int = 0
		for character in self {
			if let digit = decodeCharacters[String(character)] {
				value = value * 83 + digit
			}
		}
		return value
	}
}

private func pow(_ base: Int, _ exponent: Int) -> Int {
    return (0 ..< exponent).reduce(1) { value, _ in value * base }
}
