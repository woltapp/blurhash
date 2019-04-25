import UIKit

extension BlurHash {
	public func cgImage(size: CGSize) -> CGImage? {
		let width = Int(size.width)
		let height = Int(size.height)
		let bytesPerRow = width * 3

		guard let data = CFDataCreateMutable(kCFAllocatorDefault, bytesPerRow * height) else { return nil }
		CFDataSetLength(data, bytesPerRow * height)

		guard let pixels = CFDataGetMutableBytePtr(data) else { return nil }

		for y in 0 ..< height {
			for x in 0 ..< width {
				var c: (Float, Float, Float) = (0, 0, 0)

				for j in 0 ..< numberOfVerticalComponents {
					for i in 0 ..< numberOfHorizontalComponents {
						let basis = cos(Float.pi * Float(x) * Float(i) / Float(width)) * cos(Float.pi * Float(y) * Float(j) / Float(height))
						let component = components[j][i]
						c += component * basis
					}
				}

				let intR = UInt8(linearTosRGB(c.0))
				let intG = UInt8(linearTosRGB(c.1))
				let intB = UInt8(linearTosRGB(c.2))

				pixels[3 * x + 0 + y * bytesPerRow] = intR
				pixels[3 * x + 1 + y * bytesPerRow] = intG
				pixels[3 * x + 2 + y * bytesPerRow] = intB
			}
		}

		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)

		guard let provider = CGDataProvider(data: data) else { return nil }
		guard let cgImage = CGImage(width: width, height: height, bitsPerComponent: 8, bitsPerPixel: 24, bytesPerRow: bytesPerRow,
		space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: bitmapInfo, provider: provider, decode: nil, shouldInterpolate: true, intent: .defaultIntent) else { return nil }

		return cgImage
	}

	public func cgImage(numberOfPixels: Int = 1024, originalSize size: CGSize) -> CGImage? {
		let width: CGFloat
		let height: CGFloat
		if size.width > size.height {
			width = floor(sqrt(CGFloat(numberOfPixels) * size.width / size.height) + 0.5)
			height = floor(CGFloat(numberOfPixels) / width + 0.5)
		} else {
			height = floor(sqrt(CGFloat(numberOfPixels) * size.height / size.width) + 0.5)
			width = floor(CGFloat(numberOfPixels) / height + 0.5)
		}
		return cgImage(size: CGSize(width: width, height: height))
	}

	public func image(size: CGSize) -> UIImage? {
		guard let cgImage = cgImage(size: size) else { return nil }
		return UIImage(cgImage: cgImage)
	}

	public func image(numberOfPixels: Int = 1024, originalSize size: CGSize) -> UIImage? {
		guard let cgImage = cgImage(numberOfPixels: numberOfPixels, originalSize: size) else { return nil }
		return UIImage(cgImage: cgImage)
	}
}

@objc extension UIImage {
    public convenience init?(blurHash string: String, size: CGSize, punch: Float = 1) {
        guard let blurHash = BlurHash(string: string),
        let cgImage = blurHash.punch(punch).cgImage(size: size) else { return nil }
        self.init(cgImage: cgImage)
    }

    public convenience init?(blurHash string: String, numberOfPixels: Int = 1024, originalSize size: CGSize, punch: Float = 1) {
        guard let blurHash = BlurHash(string: string),
        let cgImage = blurHash.punch(punch).cgImage(numberOfPixels: numberOfPixels, originalSize: size) else { return nil }
        self.init(cgImage: cgImage)
    }
}
