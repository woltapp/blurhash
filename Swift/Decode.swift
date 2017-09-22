import UIKit

extension UIImage {
    public convenience init?(blurHash: String, size: CGSize, punch: Float = 1) {
        let string = blurHash as NSString
        guard string.length >= 6 else { return nil }

        let sizeFlag = string.substring(with: NSRange(location: 0, length: 1)).decode64()
        let numY = (sizeFlag >> 3) + 1
        let numX = (sizeFlag & 7) + 1

        let quantisedMaximumValue = string.substring(with: NSRange(location: 1, length: 1)).decode64()
        let maximumValue = Float(quantisedMaximumValue + 1) / 128

        guard string.length == 6 + 2 * numX * numY else { return nil }

        let colours: [(Float, Float, Float)] = (0 ... numX * numY).map { i in
            if i == 0 {
                let value = string.substring(with: NSRange(location: 2, length: 4)).decode64()
                return decodeDC(value)
            } else {
                let value = string.substring(with: NSRange(location: 4 + i * 2, length: 2)).decode64()
                return decodeAC(value, maximumValue: maximumValue * punch)
            }
        }

        let width = Int(size.width)
        let height = Int(size.height)
        let bytesPerRow = width * 3
        guard let data = CFDataCreateMutable(kCFAllocatorDefault, bytesPerRow * height) else { return nil }
        guard let pixels = CFDataGetMutableBytePtr(data) else { return nil }

        for y in 0 ..< height {
            for x in 0 ..< width {
                let baseColour = colours[0]
                var r: Float = baseColour.0
                var g: Float = baseColour.1
                var b: Float = baseColour.2

                for q in 0 ..< numY {
                    for k in 0 ..< numX {
                        let basis: Float
                        let fx = Double(x) - Double(width) / 2
                        let fy = Double(y) - Double(height) / 2
                        let rr = sqrt(fx * fx + fy * fy) / (Double(width) / 2)
                        let omega = atan2(fy, fx)
                        let K = (k + 1) / 2
                        let Rkq = UIImage.Rqk[q][K]
                        let isCosine = k % 2 == 0
                        basis = Float(1 / (sqrt(Double.pi) * abs(jn(K + 1, Rkq))) * jn(K, Rkq * rr) * (isCosine ? cos(omega * Double(K)) : sin(omega * Double(K))))

                        let colour = colours[k + q * numX + 1]
                        r += colour.0 * basis
                        g += colour.1 * basis
                        b += colour.2 * basis
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

        self.init(cgImage: cgImage)
    }
}

func decodeDC(_ value: Int) -> (Float, Float, Float) {
    let intR = value >> 16
    let intG = (value >> 8) & 255
    let intB = value & 255
    return (sRGBToLinear(intR), sRGBToLinear(intG), sRGBToLinear(intB))
}

func decodeAC(_ value: Int, maximumValue: Float) -> (Float, Float, Float) {
    let quantR = value >> 8
    let quantG = (value >> 4) & 15
    let quantB = value & 15

    let rgb = (
        signPow((Float(quantR) - 8) / 8, 3.0) * maximumValue * 2,
        signPow((Float(quantG) - 8) / 8, 3.0) * maximumValue * 2,
        signPow((Float(quantB) - 8) / 8, 3.0) * maximumValue * 2
    )

    return rgb
}
