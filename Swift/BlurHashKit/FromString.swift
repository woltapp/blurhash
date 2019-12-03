import Foundation

public extension BlurHash {
	init?(string: String) {
		guard string.count >= 6 else { return nil }

		let sizeFlag = String(string[0]).decode83()
		let numberOfHorizontalComponents = (sizeFlag % 9) + 1
		let numberOfVerticalComponents = (sizeFlag / 9) + 1

		let quantisedMaximumValue = String(string[1]).decode83()
		let maximumValue = Float(quantisedMaximumValue + 1) / 166

		guard string.count == 4 + 2 * numberOfHorizontalComponents * numberOfVerticalComponents else { return nil }

		self.components = (0 ..< numberOfVerticalComponents).map { j in
			return (0 ..< numberOfHorizontalComponents).map { i in
				if i == 0 && j == 0 {
					let value = String(string[2 ..< 6]).decode83()
					return BlurHash.decodeDC(value)
				} else {
					let index = i + j * numberOfHorizontalComponents
					let value = String(string[4 + index * 2 ..< 4 + index * 2 + 2]).decode83()
					return BlurHash.decodeAC(value, maximumValue: maximumValue)
				}
			}
		}
	}

	private static func decodeDC(_ value: Int) -> (Float, Float, Float) {
		let intR = value >> 16
		let intG = (value >> 8) & 255
		let intB = value & 255
		return (sRGBToLinear(intR), sRGBToLinear(intG), sRGBToLinear(intB))
	}

	private static func decodeAC(_ value: Int, maximumValue: Float) -> (Float, Float, Float) {
		let quantR = value / (19 * 19)
		let quantG = (value / 19) % 19
		let quantB = value % 19

		let rgb = (
			signPow((Float(quantR) - 9) / 9, 2) * maximumValue,
			signPow((Float(quantG) - 9) / 9, 2) * maximumValue,
			signPow((Float(quantB) - 9) / 9, 2) * maximumValue
		)

		return rgb
	}
}

private extension String {
	subscript (offset: Int) -> Character {
		return self[index(startIndex, offsetBy: offset)]
	}

	subscript (bounds: CountableClosedRange<Int>) -> Substring {
		let start = index(startIndex, offsetBy: bounds.lowerBound)
		let end = index(startIndex, offsetBy: bounds.upperBound)
		return self[start...end]
	}

	subscript (bounds: CountableRange<Int>) -> Substring {
		let start = index(startIndex, offsetBy: bounds.lowerBound)
		let end = index(startIndex, offsetBy: bounds.upperBound)
		return self[start..<end]
	}
}
