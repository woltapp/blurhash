import UIKit

extension UIImage {
    public convenience init?(blurHash: String, size: CGSize, punch: Float = 1) {
        let string = blurHash as NSString
        guard string.length >= 5 else { return nil }

        let sizeFlag = string.substring(with: NSRange(location: 0, length: 1)).decode64()
        let numY = (sizeFlag >> 3) + 1
        let numX = (sizeFlag & 7) + 1

print("\(numX) \(numY)")

        guard string.length == 3 + 2 * numX * numY else { return nil }

        let colours: [(Float, Float, Float)] = (0 ..< numX * numY).map { i in
            if i == 0 {
                let value = string.substring(with: NSRange(location: 1, length: 4)).decode64()
                let intR = value >> 16
                let intG = (value >> 8) & 255
                let intB = value & 255
                print("\((Float(intR), Float(intG), Float(intB)))")
                return (Float(intR), Float(intG), Float(intB))
            } else {
                let value = string.substring(with: NSRange(location: 3 + i * 2, length: 2)).decode64()
                let intR = value >> 8
                let intG = (value >> 4) & 15
                let intB = value & 15
                print("\(((Float(intR) - 8) * 4, (Float(intG) - 8) * 4, (Float(intB) - 8) * 4))")
                return ((Float(intR) - 8) * 4, (Float(intG) - 8) * 4, (Float(intB) - 8) * 4)
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
                        let boost: Float = (i == 0 && j == 0) ? 1 : punch
                        r += colour.0 * basis * boost
                        g += colour.1 * basis * boost
                        b += colour.2 * basis * boost
                    }
                }

                let scale: Float = 255
                let c = UIColor(red: CGFloat(r / scale), green: CGFloat(g / scale), blue: CGFloat(b / scale), alpha: 1)
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
