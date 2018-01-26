import Foundation

public extension BlurHash {
	init?(string: String) {
		let nsString = string as NSString
		guard nsString.length >= 6 else { return nil }

		let sizeFlag = nsString.substring(with: NSRange(location: 0, length: 1)).decode64()
		let numY = (sizeFlag >> 3) + 1
		let numX = (sizeFlag & 7) + 1

		let quantisedMaximumValue = nsString.substring(with: NSRange(location: 1, length: 1)).decode64()
		let maximumValue = Float(quantisedMaximumValue + 1) / 64

		guard nsString.length == 4 + 2 * numX * numY else { return nil }

		self.components = (0 ..< numY).map { y in
			return (0 ..< numX).map { x in
				if x == 0 && y == 0 {
					let value = nsString.substring(with: NSRange(location: 2, length: 4)).decode64()
					return BlurHash.decodeDC(value)
				} else {
					let i = x + y * numX
					let value = nsString.substring(with: NSRange(location: 4 + i * 2, length: 2)).decode64()
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
		let quantR = value >> 8
		let quantG = (value >> 4) & 15
		let quantB = value & 15

		let rgb = (
			signPow((Float(quantR) - 8) / 7, 3.0) * maximumValue,
			signPow((Float(quantG) - 8) / 7, 3.0) * maximumValue,
			signPow((Float(quantB) - 8) / 7, 3.0) * maximumValue
		)

		return rgb
	}
}
