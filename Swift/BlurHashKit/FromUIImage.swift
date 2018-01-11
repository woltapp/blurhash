import UIKit

public extension BlurHash {
	init?(image: UIImage, numberOfComponents components: (Int, Int)) {
        guard components.0 >= 1, components.0 <= 8,
        components.1 >= 1, components.1 <= 8 else {
        	fatalError("Number of components bust be between 1 and 8 inclusive on each axis")
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

        self.components = (0 ..< components.1).map { y in
            return (0 ..< components.0).map { x in
            	let normalisation: Float = (x == 0 && y == 0) ? 1 : 2
                return BlurHash.multiplyBasisFunction(pixels: pixels, width: width, height: height, bytesPerRow: bytesPerRow, bytesPerPixel: cgImage.bitsPerPixel / 8, pixelOffset: 0) {
                    normalisation * cos(Float.pi * Float(x) * $0 / Float(width)) * cos(Float.pi * Float(y) * $1 / Float(height))
                }
            }
        }
	}

    static private func multiplyBasisFunction(pixels: UnsafePointer<UInt8>, width: Int, height: Int, bytesPerRow: Int, bytesPerPixel: Int, pixelOffset: Int, basisFunction: (Float, Float) -> Float) -> (Float, Float, Float) {
        var r: Float = 0
        var g: Float = 0
        var b: Float = 0

        let buffer = UnsafeBufferPointer(start: pixels, count: height * bytesPerRow)

        for x in 0 ..< width {
            for y in 0 ..< height {
                let basis = basisFunction(Float(x), Float(y))
                r += basis * sRGBToLinear(buffer[bytesPerPixel * x + pixelOffset + 0 + y * bytesPerRow])
                g += basis * sRGBToLinear(buffer[bytesPerPixel * x + pixelOffset + 1 + y * bytesPerRow])
                b += basis * sRGBToLinear(buffer[bytesPerPixel * x + pixelOffset + 2 + y * bytesPerRow])
            }
        }

        let scale = 1 / Float(width * height)

        return (r * scale, g * scale, b * scale)
    }
}

