import UIKit

extension UIImage {
    static let Rqk: [[Double]] = [
        // TODO:
        // http://wwwal.kuicr.kyoto-u.ac.jp/www/accelerator/a4/besselroot.htmlx
        // http://www.math.usm.edu/lambers/mat415/lecture15.pdf

        [0, 1.8412, 3.0542, 4.2012, 5.3175, 6.4156],
        [3.8317, 5.3314, 6.7061, 8.0152, 9.2824, 10.5199],
        [7.0156, 8.5363, 9.9695, 11.3459, 12.6819, 13.9872],
        [10.1735, 11.7060, 13.1704, 14.5858, 15.9641, 17.3128],
        [13.3237, 14.8636, 16.3475, 17.7887, 19.1960, 20.5755],

/*        [2.4048, 3.8317, 5.1356, 6.3802, 7.5883, 8.7715],
        [5.5201, 7.0156, 8.4172, 9.7610, 11.0647, 12.3386],
        [8.6537, 10.1735, 11.6198, 13.0152, 14.3725, 15.7002],
        [11.7915, 13.3237, 14.7960, 16.2235, 17.6160, 18.9801],
        [14.9309, 16.4706, 17.9598, 19.4094, 20.8269, 22.2178],*/
    ]

    public func blurHash(components: (Int, Int)) -> String? {
        guard components.0 >= 1, components.0 <= 10,
        components.1 >= 1, components.1 <= 5,
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

        for q in 0 ..< components.1 {
            for k in 0 ..< components.0 {
                let factor = multiplyBasisFunction(pixels: pixels, width: width, height: height, bytesPerRow: bytesPerRow, bytesPerPixel: cgImage.bitsPerPixel / 8, pixelOffset: 0) {
                    let fx = Double($0) - Double(width) / 2
                    let fy = Double($1) - Double(height) / 2
                    let r = sqrt(fx * fx + fy * fy) / (Double(width) / 2)
                    let omega = atan2(fy, fx)
                    guard r < 1 else { return 0 }
                    let K = (k + 1) / 2
                    let Rkq = UIImage.Rqk[q][K]
                    let isCosine = k % 2 == 0
                    let normalisation = Rkq == 0 ? 1 : sqrt(Double.pi)
                    return Float(normalisation * jn(K, Rkq * r) * (isCosine ? cos(omega * Double(K)) : sin(omega * Double(K))))
                }

                factors.append(factor)
            }
        }

        let dc = factors.first!
        let ac = factors.dropFirst()

        var hash = ""

        let sizeFlag = (components.0 - 1) + ((components.1 - 1) * 10)
        hash += sizeFlag.encode64(length: 1)

        let maximumValue: Float
        if ac.count > 0 {
            let actualMaximumValue = ac.map({ max($0.0, $0.1, $0.2) }).max()!
            let quantisedMaximumValue = Int(max(0, min(63, floor(actualMaximumValue * 128 - 0.5))))
            maximumValue = Float(quantisedMaximumValue + 1) / 128
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
                r += basis * (sRGBToLinear(buffer[bytesPerPixel * x + pixelOffset + 0 + y * bytesPerRow]))
                g += basis * (sRGBToLinear(buffer[bytesPerPixel * x + pixelOffset + 1 + y * bytesPerRow]))
                b += basis * (sRGBToLinear(buffer[bytesPerPixel * x + pixelOffset + 2 + y * bytesPerRow]))
            }
        }

        let scale = Float(width * height)

        return (r / scale, g / scale, b / scale)
    }
}

func encodeDC(_ value: (Float, Float, Float)) -> Int {
    let roundedR = linearTosRGB(value.0)
    let roundedG = linearTosRGB(value.1)
    let roundedB = linearTosRGB(value.2)
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

func linearTosRGB(_ value: Float) -> Int {
    let v = max(0, min(1, value))
	if v <= 0.0031308 { return Int(v * 12.92 * 255 + 0.5) }
	else { return Int((1.055 * pow(v, 1 / 2.4) - 0.055) * 255 + 0.5) }
}

func sRGBToLinear<Type: Integer>(_ value: Type) -> Float {
    let v = Float(value.toIntMax()) / 255
	if v <= 0.04045 { return v / 12.92 }
	else { return pow((v + 0.055) / 1.055, 2.4) }
}
