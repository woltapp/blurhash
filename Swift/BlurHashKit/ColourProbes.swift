import Foundation

public extension BlurHash {
    public func linearRGB(atX: Float) -> (Float, Float, Float) {
        return components[0].enumerated().reduce((0, 0, 0)) { (sum, xEnumerated) in
            let (x, component) = xEnumerated
            return sum + component * cos(Float.pi * Float(x) * atX)
        }
    }

    public func linearRGB(atY: Float) -> (Float, Float, Float) {
        return components.enumerated().reduce((0, 0, 0)) { (sum, yEnumerated) in
            let (y, xComponents) = yEnumerated
            return sum + xComponents[0] * cos(Float.pi * Float(y) * atY)
        }
    }

    public func linearRGB(at position: (Float, Float)) -> (Float, Float, Float) {
        return components.enumerated().reduce((0, 0, 0)) { (sum, yEnumerated) in
            let (y, xComponents) = yEnumerated
            return xComponents.enumerated().reduce(sum) { (sum, xEnumerated) in
                let (x, component) = xEnumerated
                return sum + component * cos(Float.pi * Float(x) * position.0) * cos(Float.pi * Float(y) * position.1)
            }
        }
    }

    public var averageLinearRGB: (Float, Float, Float) {
        return components[0][0]
    }

    public var leftEdgeLinearRGB: (Float, Float, Float) { return linearRGB(atX: 0) }
    public var rightEdgeLinearRGB: (Float, Float, Float) { return linearRGB(atX: 1) }
    public var topEdgeLinearRGB: (Float, Float, Float) { return linearRGB(atY: 0) }
    public var bottomEdgeLinearRGB: (Float, Float, Float) { return linearRGB(atY: 1) }
    public var topLeftCornerLinearRGB: (Float, Float, Float) { return linearRGB(at: (0, 0)) }
    public var topRightCornerLinearRGB: (Float, Float, Float) { return linearRGB(at: (1, 0)) }
    public var bottomLeftCornerLinearRGB: (Float, Float, Float) { return linearRGB(at: (0, 1)) }
    public var bottomRightCornerLinearRGB: (Float, Float, Float) { return linearRGB(at: (1, 1)) }
}

public extension BlurHash {
    public func isDark(linearRGB rgb: (Float, Float, Float)) -> Bool {
        return rgb.0 * 0.299 + rgb.1 * 0.587 + rgb.2 * 0.114 < 0.5
    }

    public var isDark: Bool { return isDark(linearRGB: averageLinearRGB) }

    public func isDark(atX x: Float) -> Bool { return isDark(linearRGB: linearRGB(atX: x)) }
    public func isDark(atY y: Float) -> Bool { return isDark(linearRGB: linearRGB(atY: y)) }
    public func isDark(at position: (Float, Float)) -> Bool { return isDark(linearRGB: linearRGB(at: position)) }

    public var isLeftEdgeDark: Bool { return isDark(atX: 0) }
    public var isRightEdgeDark: Bool { return isDark(atX: 1) }
    public var isTopEdgeDark: Bool { return isDark(atY: 0) }
    public var isBottomEdgeDark: Bool { return isDark(atY: 1) }
    public var isTopLeftCornerDark: Bool { return isDark(at: (0, 0)) }
    public var isTopRightCornerDark: Bool { return isDark(at: (1, 0)) }
    public var isBottomLeftCornerDark: Bool { return isDark(at: (0, 1)) }
    public var isBottomRightCornerDark: Bool { return isDark(at: (1, 1)) }
}
