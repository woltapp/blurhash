import UIKit

public extension BlurHash {
	init?(image: UIImage, numberOfComponents components: (Int, Int)) {
		guard components.0 >= 1, components.0 <= 9,
		components.1 >= 1, components.1 <= 9 else {
			fatalError("Number of components bust be between 1 and 9 inclusive on each axis")
		}

		guard let cgImage = image.cgImage,
		let dataProvider = cgImage.dataProvider,
		let data = dataProvider.data,
		let pixels = CFDataGetBytePtr(data),
		cgImage.colorSpace?.numberOfComponents == 3,
		cgImage.bitsPerPixel == 24 || cgImage.bitsPerPixel == 32 else {
			assertionFailure("Invalid image format")
			return nil
		}

		let width = cgImage.width
		let height = cgImage.height
		let bytesPerRow = cgImage.bytesPerRow

		self.components = (0 ..< components.1).map { j -> [(Float, Float, Float)] in
			return (0 ..< components.0).map { i -> (Float, Float, Float) in
				let normalisation: Float = (i == 0 && j == 0) ? 1 : 2
				return BlurHash.multiplyBasisFunction(pixels: pixels, width: width, height: height, bytesPerRow: bytesPerRow, bytesPerPixel: cgImage.bitsPerPixel / 8, pixelOffset: 0) { x, y in
					normalisation * cos(Float.pi * Float(i) * x / Float(width)) as Float * cos(Float.pi * Float(j) * y / Float(height)) as Float
				}
			}
		}
	}

	static private func multiplyBasisFunction(pixels: UnsafePointer<UInt8>, width: Int, height: Int, bytesPerRow: Int, bytesPerPixel: Int, pixelOffset: Int, basisFunction: (Float, Float) -> Float) -> (Float, Float, Float) {
		var c: (Float, Float, Float) = (0, 0, 0)

		let buffer = UnsafeBufferPointer(start: pixels, count: height * bytesPerRow)

		for x in 0 ..< width {
			for y in 0 ..< height {
				c += basisFunction(Float(x), Float(y)) * (
					sRGBToLinear(buffer[bytesPerPixel * x + pixelOffset + 0 + y * bytesPerRow]),
					sRGBToLinear(buffer[bytesPerPixel * x + pixelOffset + 1 + y * bytesPerRow]),
					sRGBToLinear(buffer[bytesPerPixel * x + pixelOffset + 2 + y * bytesPerRow])
				)
			}
		}

		return c / Float(width * height)
	}
}

