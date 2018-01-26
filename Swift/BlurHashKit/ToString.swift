import Foundation

public extension BlurHash {
	var string: String {
		let flatComponents = components.reduce([]) { $0 + $1 }
		let dc = flatComponents.first!
		let ac = flatComponents.dropFirst()

		var hash = ""

		let sizeFlag = (numberOfHorizontalComponents - 1) + ((numberOfVerticalComponents - 1) << 3)
		hash += sizeFlag.encode64(length: 1)

		let maximumValue: Float
		if ac.count > 0 {
			let actualMaximumValue = ac.map({ max(abs($0.0), abs($0.1), abs($0.2)) }).max()!
			let quantisedMaximumValue = Int(max(0, min(63, floor(actualMaximumValue * 64 - 0.5))))
			maximumValue = Float(quantisedMaximumValue + 1) / 64
			hash += quantisedMaximumValue.encode64(length: 1)
		} else {
			maximumValue = 1
			hash += 0.encode64(length: 1)
		}

		hash += encodeDC(dc).encode64(length: 4)

		for factor in ac {
			hash += encodeAC(factor, maximumValue: maximumValue).encode64(length: 2)
		}

		return hash
	}

	private func encodeDC(_ value: (Float, Float, Float)) -> Int {
		let roundedR = linearTosRGB(value.0)
		let roundedG = linearTosRGB(value.1)
		let roundedB = linearTosRGB(value.2)
		return (roundedR << 16) + (roundedG << 8) + roundedB
	}

	private func encodeAC(_ value: (Float, Float, Float), maximumValue: Float) -> Int {
		let quantR = Int(max(0, min(15, floor(signPow(value.0 / maximumValue, 0.333) * 7 + 8.5))))
		let quantG = Int(max(0, min(15, floor(signPow(value.1 / maximumValue, 0.333) * 7 + 8.5))))
		let quantB = Int(max(0, min(15, floor(signPow(value.2 / maximumValue, 0.333) * 7 + 8.5))))

		return (quantR << 8) + (quantG << 4) + quantB
	}
}
