import UIKit

public extension BlurHash {
	public func cgImage(size: CGSize) -> CGImage? {
		let width = Int(size.width)
		let height = Int(size.height)
		let bytesPerRow = width * 3

		guard let data = CFDataCreateMutable(kCFAllocatorDefault, bytesPerRow * height) else { return nil }
		CFDataSetLength(data, bytesPerRow * height)

		guard let pixels = CFDataGetMutableBytePtr(data) else { return nil }

		for y in 0 ..< height {
			for x in 0 ..< width {
				var r: Float = 0
				var g: Float = 0
				var b: Float = 0

				for j in 0 ..< numberOfVerticalComponents {
					for i in 0 ..< numberOfHorizontalComponents {
						let basis = cos(Float.pi * Float(x) * Float(i) / Float(width)) * cos(Float.pi * Float(y) * Float(j) / Float(height))
						let component = components[j][i]
						r += component.0 * basis
						g += component.1 * basis
						b += component.2 * basis
					}
				}

				let intR = UInt8(linearTosRGB(r))
				let intG = UInt8(linearTosRGB(g))
				let intB = UInt8(linearTosRGB(b))

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

	public func image(size: CGSize) -> UIImage? {
		guard let cgImage = cgImage(size: size) else { return nil }
		return UIImage(cgImage: cgImage)
	}

	public func image(numberOfPixels: Int = 1024, originalSize size: CGSize) -> UIImage? {
		let width: CGFloat
		let height: CGFloat
		if size.width > size.height {
			width = floor(sqrt(CGFloat(numberOfPixels)) * size.width / size.height + 0.5)
			height = floor(CGFloat(numberOfPixels) / width + 0.5)
		} else {
			height = floor(sqrt(CGFloat(numberOfPixels)) * size.height / size.width + 0.5)
			width = floor(CGFloat(numberOfPixels) / height + 0.5)
		}
		return image(size: CGSize(width: width, height: height))
	}
}

