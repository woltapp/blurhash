import UIKit

extension UIImage {
//    let quantizationTable: (Float, Float, Float) = [
//    ]

    public func blurHash(components: (Int, Int)) -> String? {
        guard components.0 >= 1, components.0 <= 8,
        components.1 >= 1, components.1 <= 8,
        cgImage?.colorSpace?.numberOfComponents == 3,
        cgImage?.bitsPerPixel == 24 || cgImage?.bitsPerPixel == 32 else { return nil }

        guard let cgImage = cgImage,
        let dataProvider = cgImage.dataProvider,
        let data = dataProvider.data,
        let pixels = CFDataGetBytePtr(data) else { return nil }

        let width = cgImage.width
        let height = cgImage.height
        let bytesPerRow = cgImage.bytesPerRow

        var factors: [(Float, Float, Float)] = []
        for y in 0 ..< components.1 {
            for x in 0 ..< components.0 {
                let factor = multiplyBasisFunction(pixels: pixels, width: width, height: height, bytesPerRow: bytesPerRow, bytesPerPixel: cgImage.bitsPerPixel / 8, pixelOffset: 0) {
                    cos(Float.pi * Float(x) * $0 / Float(width)) * cos(Float.pi * Float(y) * $1 / Float(height))
                }
                factors.append(factor)
            }
        }

        let dc = factors.first!
        let ac = factors.dropFirst()

        var hash = ""

        let sizeFlag = (components.0 - 1) + ((components.1 - 1) << 3)
        hash += sizeFlag.encode64(length: 1)

        let actualMaximumValue = ac.map({ max($0.0, $0.1, $0.2) }).max()!
        let quantisedMaximumValue = Int(max(0, min(63, floor(actualMaximumValue * 128 - 0.5))))
        let maximumValue = Float(quantisedMaximumValue + 1) / 128
        hash += quantisedMaximumValue.encode64(length: 1)

        hash += encodeDC(dc).encode64(length: 4)

        for factor in ac {
            hash += encodeAC(factor, maximumValue: maximumValue).encode64(length: 2)
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
                r += basis * gammaToLinear(buffer[bytesPerPixel * x + pixelOffset + 0 + y * bytesPerRow])
                g += basis * gammaToLinear(buffer[bytesPerPixel * x + pixelOffset + 1 + y * bytesPerRow])
                b += basis * gammaToLinear(buffer[bytesPerPixel * x + pixelOffset + 2 + y * bytesPerRow])
            }
        }

        let scale = Float(width * height)

        return (r / scale, g / scale, b / scale)
    }

//        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: CGFloat(size), height: CGFloat(size)))
}

func linearToGamma(_ value: Float) -> Int {
    return Int(max(0, min(255, floor(pow(value, 1 / 2.2) * 255) + 0.5)))
}

func gammaToLinear(_ value: UInt8) -> Float {
    return pow(Float(value) / 255, 2.2)
}

func gammaToLinear(_ value: Int) -> Float {
    return pow(Float(value) / 255, 2.2)
}

func encodeDC(_ value: (Float, Float, Float)) -> Int {
    let roundedR = linearToGamma(value.0)
    let roundedG = linearToGamma(value.1)
    let roundedB = linearToGamma(value.2)
    return (roundedR << 16) + (roundedG << 8) + roundedB
}

func encodeAC(_ value: (Float, Float, Float), maximumValue: Float) -> Int {
    let quantR = Int(max(0, min(15, floor(signPow(value.0 / maximumValue, 0.333) * 8 + 8.5))))
    let quantG = Int(max(0, min(15, floor(signPow(value.1 / maximumValue, 0.333) * 8 + 8.5))))
    let quantB = Int(max(0, min(15, floor(signPow(value.2 / maximumValue, 0.333) * 8 + 8.5))))

    return (quantR << 8) + (quantG << 4) + quantB
}

func signPow(_ value: Float, _ exp: Float) -> Float {
    return copysign(pow(abs(value), exp), value)
}

