import Foundation

extension BlurHash {
    public func linearRgb(atX: Float) -> (Float, Float, Float) {
        return components[0].enumerated().reduce((0, 0, 0)) { (sum, xEnumerated) in
            let (x, component) = xEnumerated
            return sum + component * cos(Float.pi * Float(x) * atX)
        }
    }

    public func linearRgb(atY: Float) -> (Float, Float, Float) {
        return components.enumerated().reduce((0, 0, 0)) { (sum, yEnumerated) in
            let (y, xComponents) = yEnumerated
            return sum + xComponents[0] * cos(Float.pi * Float(y) * atY)
        }
    }

    public func linearRgb(at position: (Float, Float)) -> (Float, Float, Float) {
        return components.enumerated().reduce((0, 0, 0)) { (sum, yEnumerated) in
            let (y, xComponents) = yEnumerated
            return xComponents.enumerated().reduce(sum) { (sum, xEnumerated) in
                let (x, component) = xEnumerated
                return sum + component * cos(Float.pi * Float(x) * position.0) * cos(Float.pi * Float(y) * position.1)
            }
        }
    }

    public func linearRgb(from upperLeft: (Float, Float), to lowerRight: (Float, Float)) -> (Float, Float, Float) {
        return components.enumerated().reduce((0, 0, 0)) { (sum, yEnumerated) in
            let (y, xComponents) = yEnumerated
            return xComponents.enumerated().reduce(sum) { (sum, xEnumerated) in
                let (x, component) = xEnumerated
                let horizontalAverage: Float = x == 0 ? 1 : (sin(Float.pi * Float(x) * lowerRight.0) - sin(Float.pi * Float(x) * upperLeft.0)) / (Float(x) * Float.pi * (lowerRight.0 - upperLeft.0))
                let veritcalAverage: Float = y == 0 ? 1 : (sin(Float.pi * Float(y) * lowerRight.1) - sin(Float.pi * Float(y) * upperLeft.1)) / (Float(y) * Float.pi * (lowerRight.1 - upperLeft.1))
                return sum + component * horizontalAverage * veritcalAverage
            }
        }
    }

    public func linearRgb(at upperLeft: (Float, Float), size: (Float, Float)) -> (Float, Float, Float) {
        return linearRgb(from: upperLeft, to: (upperLeft.0 + size.0, upperLeft.1 + size.1))
    }

    public var averageLinearRgb: (Float, Float, Float) {
        return components[0][0]
    }

    public var leftEdgeLinearRgb: (Float, Float, Float) { return linearRgb(atX: 0) }
    public var rightEdgeLinearRgb: (Float, Float, Float) { return linearRgb(atX: 1) }
    public var topEdgeLinearRgb: (Float, Float, Float) { return linearRgb(atY: 0) }
    public var bottomEdgeLinearRgb: (Float, Float, Float) { return linearRgb(atY: 1) }
    public var topLeftCornerLinearRgb: (Float, Float, Float) { return linearRgb(at: (0, 0)) }
    public var topRightCornerLinearRgb: (Float, Float, Float) { return linearRgb(at: (1, 0)) }
    public var bottomLeftCornerLinearRgb: (Float, Float, Float) { return linearRgb(at: (0, 1)) }
    public var bottomRightCornerLinearRgb: (Float, Float, Float) { return linearRgb(at: (1, 1)) }
}

extension BlurHash {
    public func isDark(linearRgb rgb: (Float, Float, Float)) -> Bool {
        return rgb.0 * 0.299 + rgb.1 * 0.587 + rgb.2 * 0.114 < 0.5
    }

    public var isDark: Bool { return isDark(linearRgb: averageLinearRgb) }

    public func isDark(atX x: Float) -> Bool { return isDark(linearRgb: linearRgb(atX: x)) }
    public func isDark(atY y: Float) -> Bool { return isDark(linearRgb: linearRgb(atY: y)) }
    public func isDark(at position: (Float, Float)) -> Bool { return isDark(linearRgb: linearRgb(at: position)) }
    public func isDark(from upperLeft: (Float, Float), to lowerRight: (Float, Float)) -> Bool { return isDark(linearRgb: linearRgb(from: upperLeft, to: lowerRight)) }
    public func isDark(at upperLeft: (Float, Float), size: (Float, Float)) -> Bool { return isDark(linearRgb: linearRgb(at: upperLeft, size: size)) }

    public var isLeftEdgeDark: Bool { return isDark(atX: 0) }
    public var isRightEdgeDark: Bool { return isDark(atX: 1) }
    public var isTopEdgeDark: Bool { return isDark(atY: 0) }
    public var isBottomEdgeDark: Bool { return isDark(atY: 1) }
    public var isTopLeftCornerDark: Bool { return isDark(at: (0, 0)) }
    public var isTopRightCornerDark: Bool { return isDark(at: (1, 0)) }
    public var isBottomLeftCornerDark: Bool { return isDark(at: (0, 1)) }
    public var isBottomRightCornerDark: Bool { return isDark(at: (1, 1)) }
}
