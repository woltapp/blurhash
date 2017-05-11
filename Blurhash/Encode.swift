import UIKit

extension UIImage {
    public func blurHash(components: (Int, Int)) -> String? {
        guard components.0 >= 1, components.0 <= 8,
        components.1 >= 1, components.1 <= 8,
        cgImage?.colorSpace?.numberOfComponents == 3,
        cgImage?.bitsPerPixel == 24 || cgImage?.bitsPerPixel == 32 else { return nil }

        guard let cgImage = cgImage,
        let dataProvider = cgImage.dataProvider,
        let data = dataProvider.data,
        let pixels = CFDataGetBytePtr(data) else { return nil }

        let sizeFlag = (components.0 - 1) + ((components.1 - 1) << 3)
        var hash = sizeFlag.encode64(length: 1)

        let width = cgImage.width
        let height = cgImage.height
        let bytesPerRow = cgImage.bytesPerRow

        for y in 0 ..< components.1 {
            for x in 0 ..< components.0 {
                let (r, g, b) = multiplyBasisFunction(pixels: pixels, width: width, height: height, bytesPerRow: bytesPerRow, bytesPerPixel: cgImage.bitsPerPixel / 8, pixelOffset: 0) {
                    cos(Float.pi * Float(x) * $0 / Float(width)) * cos(Float.pi * Float(y) * $1 / Float(height))
                }

print("\((r,g,b))")

                if x == 0, y == 0 {
                    let roundedR = max(0, min(255, Int(floor(r + 0.5))))
                    let roundedG = max(0, min(255, Int(floor(g + 0.5))))
                    let roundedB = max(0, min(255, Int(floor(b + 0.5))))
                    let rgb = (roundedR << 16) + (roundedG << 8) + roundedB
                    hash += rgb.encode64(length: 4)
                } else {
                    let clippedR = max(0, min(15, Int(floor(r / 4 + 8.5))))
                    let clippedG = max(0, min(15, Int(floor(g / 4 + 8.5))))
                    let clippedB = max(0, min(15, Int(floor(b / 4 + 8.5))))
                    let rgb = (clippedR << 8) + (clippedG << 4) + clippedB
                    hash += rgb.encode64(length: 2)
                }
            }
        }

        return hash
    }

    private func multiplyBasisFunction(pixels: UnsafePointer<UInt8>, width: Int, height: Int, bytesPerRow: Int, bytesPerPixel: Int, pixelOffset: Int, basisFunction: (Float, Float) -> Float) -> (Float, Float, Float) {
        var r: Float = 0
        var g: Float = 0
        var b: Float = 0

        let buffer = UnsafeBufferPointer(start: pixels, count: height * bytesPerRow)

        for x in 0 ..< width {
            for y in 0 ..< height {
                let basis = basisFunction(Float(x), Float(y))
                r += basis * Float(buffer[bytesPerPixel * x + pixelOffset + 0 + y * bytesPerRow])
                g += basis * Float(buffer[bytesPerPixel * x + pixelOffset + 1 + y * bytesPerRow])
                b += basis * Float(buffer[bytesPerPixel * x + pixelOffset + 2 + y * bytesPerRow])
            }
        }

        let scale = Float(width * height)

        return (r / scale, g / scale, b / scale)
    }

//        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: CGFloat(size), height: CGFloat(size)))
}
