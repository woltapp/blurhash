import UIKit

extension BlurHash {
	public init(blendingTop top: BlurHash, bottom: BlurHash) {
		guard top.components.count == 1, bottom.components.count == 1 else {
			fatalError("Blended BlurHashses must have only one vertical component")
		}

		let average = zip(top.components[0], bottom.components[0]).map { ($0 + $1) / 2 }
		let difference = zip(top.components[0], bottom.components[0]).map { ($0 - $1) / 2 }
		self.init(components: [average, difference])
	}

	public init(blendingLeft left: BlurHash, right: BlurHash) {
		self = BlurHash(blendingTop: left.transposed, bottom: right.transposed).transposed
	}
}

extension BlurHash {
	public init(colour: UIColor) {
		self.init(components: [[colour.linear]])
	}

	public init(blendingTop topColour: UIColor, bottom bottomColour: UIColor) {
		self = BlurHash(blendingTop: .init(colour: topColour), bottom: .init(colour: bottomColour))
	}

	public init(blendingLeft leftColour: UIColor, right rightColour: UIColor) {
		self = BlurHash(blendingLeft: .init(colour: leftColour), right: .init(colour: rightColour))
	}

	public init(blendingTopLeft topLeftColour: UIColor, topRight topRightColour: UIColor, bottomLeft bottomLeftColour: UIColor, bottomRight bottomRightColour: UIColor) {
		self = BlurHash(
			blendingTop: BlurHash(blendingTop: topLeftColour, bottom: topRightColour).transposed,
			bottom: BlurHash(blendingTop: bottomLeftColour, bottom: bottomRightColour).transposed
		)
	}
}

extension BlurHash {
	public init(horizontalColours colours: [(Float, Float, Float)], numberOfComponents: Int) {
		guard numberOfComponents >= 1, numberOfComponents <= 9 else {
			fatalError("Number of components bust be between 1 and 9 inclusive")
		}

		self.init(components: [(0 ..< numberOfComponents).map { i in
			let normalisation: Float = i == 0 ? 1 : 2
			var sum: (Float, Float, Float) = (0, 0, 0)
			for x in 0 ..< colours.count {
				let basis = normalisation * cos(Float.pi * Float(i) * Float(x) / Float(colours.count - 1))
				sum += basis * colours[x]
			}

			return sum / Float(colours.count)
		}])
	}
}

extension BlurHash {
	public var mirroredHorizontally: BlurHash {
		return .init(components: (0 ..< numberOfVerticalComponents).map { j -> [(Float, Float, Float)] in
			(0 ..< numberOfHorizontalComponents).map { i -> (Float, Float, Float) in
				components[j][i] * (i % 2 == 0 ? 1 : -1)
			}
		})
	}

	public var mirroredVertically: BlurHash {
		return .init(components: (0 ..< numberOfVerticalComponents).map { j -> [(Float, Float, Float)] in
			(0 ..< numberOfHorizontalComponents).map { i -> (Float, Float, Float) in
				components[j][i] * (j % 2 == 0 ? 1 : -1)
			}
		})
	}

	public var transposed: BlurHash {
		return .init(components: (0 ..< numberOfHorizontalComponents).map { i in
			(0 ..< numberOfVerticalComponents).map { j in
				components[j][i]
			}
		})
	}
}

extension UIColor {
	var linear: (Float, Float, Float) {
		guard let c = cgColor.converted(to: CGColorSpace(name: CGColorSpace.sRGB)!, intent: .defaultIntent, options: nil)?.components else { return (0, 0, 0) }

		switch c.count {
			case 1, 2: return (sRGBToLinear(c[0]), sRGBToLinear(c[0]), sRGBToLinear(c[0]))
			case 3, 4: return (sRGBToLinear(c[0]), sRGBToLinear(c[1]), sRGBToLinear(c[2]))
			default: return (0, 0, 0)
		}
	}
}

func sRGBToLinear(_ value: CGFloat) -> Float {
	let v = Float(value)
	if v <= 0.04045 { return v / 12.92 }
	else { return pow((v + 0.055) / 1.055, 2.4) }
}

