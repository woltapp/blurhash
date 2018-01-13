import UIKit

public extension BlurHash {
	public init(horizontalGradientFrom leftColour: UIColor, to rightColour: UIColor) {
		let average = (leftColour.linear + rightColour.linear) / 2
		let difference = (leftColour.linear - rightColour.linear) / 2
		self.components = [[average, difference]]
	}

	public init(verticalGradientFrom leftColour: UIColor, to rightColour: UIColor) {
		let average = (leftColour.linear + rightColour.linear) / 2
		let difference = (leftColour.linear - rightColour.linear) / 2
		self.components = [[average], [difference]]
	}

	public init(blendingTopLeft topLeftColour: UIColor, topRight topRightColour: UIColor, bottomLeft bottomLeftColour: UIColor, bottomRight bottomRightColour: UIColor) {
		let average = (topLeftColour.linear + topRightColour.linear + bottomLeftColour.linear + bottomRightColour.linear) / 4
		let horizontalDifference = (topLeftColour.linear - topRightColour.linear + bottomLeftColour.linear - bottomRightColour.linear) / 4
		let verticalDifference = (topLeftColour.linear + topRightColour.linear - bottomLeftColour.linear - bottomRightColour.linear) / 4
		let diagonalDifference = (topLeftColour.linear - topRightColour.linear - bottomLeftColour.linear + bottomRightColour.linear) / 4

		self.components = [[average, horizontalDifference], [verticalDifference, diagonalDifference]]
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

