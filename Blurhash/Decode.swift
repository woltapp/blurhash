import UIKit

extension UIImage {
    public convenience init?(blurHash: String, size: CGSize, punch: Float = 1) {
        let components = blurHash.components(separatedBy: ",")

        guard components.count >= 2,
        let numX = Int(components[0]),
        let numY = Int(components[1]),
        components.count == 2 + 3 * numX * numY else { return nil }

        let colours: [(Float, Float, Float)] = (0 ..< numX * numY).map { i in
            let r = Float(components[2 + 3 * i + 0])!
            let g = Float(components[2 + 3 * i + 1])!
            let b = Float(components[2 + 3 * i + 2])!
            return (r, g, b)
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
