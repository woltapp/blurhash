import UIKit

public extension BlurHash {
	init?(image: UIImage, numberOfComponents components: (Int, Int)) {
		guard components.0 >= 1, components.0 <= 9,
		components.1 >= 1, components.1 <= 9 else {
			fatalError("Number of components bust be between 1 and 9 inclusive on each axis")
		}

		let pixelWidth = Int(round(image.size.width * image.scale))
		let pixelHeight = Int(round(image.size.height * image.scale))

		let context = CGContext(
			data: nil,
			width: pixelWidth,
			height: pixelHeight,
			bitsPerComponent: 8,
			bytesPerRow: pixelWidth * 4,
			space: CGColorSpace(name: CGColorSpace.sRGB)!,
			bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
		)!
		context.scaleBy(x: image.scale, y: -image.scale)
		context.translateBy(x: 0, y: -image.size.height)

		UIGraphicsPushContext(context)
		image.draw(at: .zero)
		UIGraphicsPopContext()

		guard let cgImage = context.makeImage(),
		let dataProvider = cgImage.dataProvider,
		let data = dataProvider.data,
		let pixels = CFDataGetBytePtr(data) else {
			assertionFailure("Unexpected error!")
			return nil
		}

		let width = cgImage.width
		let height = cgImage.height
		let bytesPerRow = cgImage.bytesPerRow

		self.components = (0 ..< components.1).map { j -> [(Float, Float, Float)] in
			return (0 ..< components.0).map { i -> (Float, Float, Float) in
				let normalisation: Float = (i == 0 && j == 0) ? 1 : 2
				return BlurHash.multiplyBasisFunction(pixels: pixels, width: width, height: height, bytesPerRow: bytesPerRow, bytesPerPixel: cgImage.bitsPerPixel / 8) { x, y in
					normalisation * cos(Float.pi * Float(i) * x / Float(width)) as Float * cos(Float.pi * Float(j) * y / Float(height)) as Float
				}
			}
		}
	}

	static private func multiplyBasisFunction(pixels: UnsafePointer<UInt8>, width: Int, height: Int, bytesPerRow: Int, bytesPerPixel: Int, basisFunction: (Float, Float) -> Float) -> (Float, Float, Float) {
		var c: (Float, Float, Float) = (0, 0, 0)

		let buffer = UnsafeBufferPointer(start: pixels, count: height * bytesPerRow)

		for x in 0 ..< width {
			for y in 0 ..< height {
				c += basisFunction(Float(x), Float(y)) * (
					sRGBToLinear(buffer[bytesPerPixel * x + 0 + y * bytesPerRow]),
					sRGBToLinear(buffer[bytesPerPixel * x + 1 + y * bytesPerRow]),
					sRGBToLinear(buffer[bytesPerPixel * x + 2 + y * bytesPerRow])
				)
			}
		}

		return c / Float(width * height)
	}
}

