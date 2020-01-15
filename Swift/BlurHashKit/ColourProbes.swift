import Foundation

extension BlurHash {
    public func linearRGB(atX x: Float) -> (Float, Float, Float) {
        return components[0].enumerated().reduce((0, 0, 0)) { (sum, horizontalEnumerated) -> (Float, Float, Float) in
            let (i, component) = horizontalEnumerated
            return sum + component * cos(Float.pi * Float(i) * x)
        }
    }

    public func linearRGB(atY y: Float) -> (Float, Float, Float) {
        return components.enumerated().reduce((0, 0, 0)) { (sum, verticalEnumerated) in
            let (j, horizontalComponents) = verticalEnumerated
            return sum + horizontalComponents[0] * cos(Float.pi * Float(j) * y)
        }
    }

    public func linearRGB(at position: (Float, Float)) -> (Float, Float, Float) {
        return components.enumerated().reduce((0, 0, 0)) { (sum, verticalEnumerated) in
            let (j, horizontalComponents) = verticalEnumerated
            return horizontalComponents.enumerated().reduce(sum) { (sum, horizontalEnumerated) in
                let (i, component) = horizontalEnumerated
                return sum + component * cos(Float.pi * Float(i) * position.0) * cos(Float.pi * Float(j) * position.1)
            }
        }
    }

    public func linearRGB(from upperLeft: (Float, Float), to lowerRight: (Float, Float)) -> (Float, Float, Float) {
        return components.enumerated().reduce((0, 0, 0)) { (sum, verticalEnumerated) in
            let (j, horizontalComponents) = verticalEnumerated
            return horizontalComponents.enumerated().reduce(sum) { (sum, horizontalEnumerated) in
                let (i, component) = horizontalEnumerated
                let horizontalAverage: Float = i == 0 ? 1 : (sin(Float.pi * Float(i) * lowerRight.0) - sin(Float.pi * Float(i) * upperLeft.0)) / (Float(i) * Float.pi * (lowerRight.0 - upperLeft.0))
                let veritcalAverage: Float = j == 0 ? 1 : (sin(Float.pi * Float(j) * lowerRight.1) - sin(Float.pi * Float(j) * upperLeft.1)) / (Float(j) * Float.pi * (lowerRight.1 - upperLeft.1))
                return sum + component * horizontalAverage * veritcalAverage
            }
        }
    }

    public func linearRGB(at upperLeft: (Float, Float), size: (Float, Float)) -> (Float, Float, Float) {
        return linearRGB(from: upperLeft, to: (upperLeft.0 + size.0, upperLeft.1 + size.1))
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

extension BlurHash {
    public func isDark(linearRGB rgb: (Float, Float, Float), threshold: Float = 0.3) -> Bool {
        return rgb.0 * 0.299 + rgb.1 * 0.587 + rgb.2 * 0.114 < threshold
    }

    public func isDark(threshold: Float = 0.3) -> Bool { return isDark(linearRGB: averageLinearRGB, threshold: threshold) }

    public func isDark(atX x: Float, threshold: Float = 0.3) -> Bool { return isDark(linearRGB: linearRGB(atX: x), threshold: threshold) }
    public func isDark(atY y: Float, threshold: Float = 0.3) -> Bool { return isDark(linearRGB: linearRGB(atY: y), threshold: threshold) }
    public func isDark(at position: (Float, Float), threshold: Float = 0.3) -> Bool { return isDark(linearRGB: linearRGB(at: position), threshold: threshold) }
    public func isDark(from upperLeft: (Float, Float), to lowerRight: (Float, Float), threshold: Float = 0.3) -> Bool { return isDark(linearRGB: linearRGB(from: upperLeft, to: lowerRight), threshold: threshold) }
    public func isDark(at upperLeft: (Float, Float), size: (Float, Float), threshold: Float = 0.3) -> Bool { return isDark(linearRGB: linearRGB(at: upperLeft, size: size), threshold: threshold) }

    public var isLeftEdgeDark: Bool { return isDark(atX: 0) }
    public var isRightEdgeDark: Bool { return isDark(atX: 1) }
    public var isTopEdgeDark: Bool { return isDark(atY: 0) }
    public var isBottomEdgeDark: Bool { return isDark(atY: 1) }
    public var isTopLeftCornerDark: Bool { return isDark(at: (0, 0)) }
    public var isTopRightCornerDark: Bool { return isDark(at: (1, 0)) }
    public var isBottomLeftCornerDark: Bool { return isDark(at: (0, 1)) }
    public var isBottomRightCornerDark: Bool { return isDark(at: (1, 1)) }
}
