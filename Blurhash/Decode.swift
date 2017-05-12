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

        guard string.length == 4 + 2 * numX * numY else { return nil }

        let colours: [(Float, Float, Float)] = (0 ..< numX * numY).map { i in
            if i == 0 {
                let value = string.substring(with: NSRange(location: 2, length: 4)).decode64()
                return decodeDC(value)
            } else {
                let value = string.substring(with: NSRange(location: 4 + i * 2, length: 2)).decode64()
                return decodeAC(value, maximumValue: maximumValue * punch)
            }
        }

        UIGraphicsBeginImageContextWithOptions(size, false, 1)

        let width = Int(size.width)
        let height = Int(size.height)

        for y in 0 ..< height {
            for x in 0 ..< width {
                var r: Float = 0
                var g: Float = 0
                var b: Float = 0

                for j in 0 ..< numY {
                    for i in 0 ..< numX {
                        let basis = cos(Float.pi * Float(x) * Float(i) / Float(width)) * cos(Float.pi * Float(y) * Float(j) / Float(height))
                        let colour = colours[i + j * numX]
                        r += colour.0 * basis
                        g += colour.1 * basis
                        b += colour.2 * basis
                    }
                }

                let c = UIColor(red: CGFloat(pow(r, 1 / 2.2)),
                green: CGFloat(pow(g, 1 / 2.2)),
                blue: CGFloat(pow(b, 1 / 2.2)),
                alpha: 1)
                c.setFill()
                UIRectFill(CGRect(x: x, y: y, width: 1, height: 1))
            }
        }

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if let cgImage = newImage?.cgImage {
            self.init(cgImage: cgImage)
        } else {
            return nil
        }
    }
}

func decodeDC(_ value: Int) -> (Float, Float, Float) {
    let intR = value >> 16
    let intG = (value >> 8) & 255
    let intB = value & 255
    return (gammaToLinear(intR), gammaToLinear(intG), gammaToLinear(intB))
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
