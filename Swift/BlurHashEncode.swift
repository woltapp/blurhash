import UIKit

extension UIImage {
    public func blurHash(numberOfComponents components: (Int, Int)) -> String? {
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
                let normalisation: Float = (x == 0 && y == 0) ? 1 : 2
                let factor = multiplyBasisFunction(pixels: pixels, width: width, height: height, bytesPerRow: bytesPerRow, bytesPerPixel: cgImage.bitsPerPixel / 8, pixelOffset: 0) {
                    normalisation * cos(Float.pi * Float(x) * $0 / Float(width)) * cos(Float.pi * Float(y) * $1 / Float(height))
                }
                factors.append(factor)
            }
        }

        let dc = factors.first!
        let ac = factors.dropFirst()

        var hash = ""

        let sizeFlag = (components.0 - 1) + ((components.1 - 1) << 3)
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

    private func multiplyBasisFunction(pixels: UnsafePointer<UInt8>, width: Int, height: Int, bytesPerRow: Int, bytesPerPixel: Int, pixelOffset: Int, basisFunction: (Float, Float) -> Float) -> (Float, Float, Float) {
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

private func signPow(_ value: Float, _ exp: Float) -> Float {
    return copysign(pow(abs(value), exp), value)
}

private func linearTosRGB(_ value: Float) -> Int {
    let v = max(0, min(1, value))
    if v <= 0.0031308 { return Int(v * 12.92 * 255 + 0.5) }
    else { return Int((1.055 * pow(v, 1 / 2.4) - 0.055) * 255 + 0.5) }
}

private func sRGBToLinear<Type: BinaryInteger>(_ value: Type) -> Float {
    let v = Float(Int64(value)) / 255
    if v <= 0.04045 { return v / 12.92 }
    else { return pow((v + 0.055) / 1.055, 2.4) }
}

private let digitCharacters = [
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
    "k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
    "u", "v", "w", "x", "y", "z", "A", "B", "C", "D",
    "E", "F", "G", "H", "I", "J", "K", "L", "M", "N",
    "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X",
    "Y", "Z", ":", ";"
]

private extension Int {
    func encode64(length: Int) -> String {
        var result = ""
        for i in 1 ... length {
            let digit = (self >> (6 * (length - i))) & 63
            result += digitCharacters[digit]
        }
        return result
    }
}
