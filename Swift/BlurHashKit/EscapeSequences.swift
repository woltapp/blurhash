import Foundation

extension BlurHash {
    var twoByThreeEscapeSequence: String {
        let areas: [(from: (Float, Float), to: (Float, Float))] = [
            (from: (0, 0), to: (0.333, 0.5)),
            (from: (0, 0.5), to: (0.333, 1.0)),
            (from: (0.333, 0), to: (0.666, 0.5)),
            (from: (0.333, 0.5), to: (0.666, 1.0)),
            (from: (0.666, 0), to: (1.0, 0.5)),
            (from: (0.666, 0.5), to: (1.0, 1.0)),
        ]

        let rgb: [(Float, Float, Float)] = areas.map { area in
            linearRGB(from: area.from, to: area.to)
        }

        let maxRgb: (Float, Float, Float) = rgb.reduce((-Float.infinity, -Float.infinity, -Float.infinity), max)
        let minRgb: (Float, Float, Float) = rgb.reduce((Float.infinity, Float.infinity, Float.infinity), min)

        let positiveScale: (Float, Float, Float) = ((1, 1, 1) - averageLinearRGB) / (maxRgb - averageLinearRGB)
        let negativeScale: (Float, Float, Float) = averageLinearRGB / (averageLinearRGB - minRgb)
        let scale: (Float, Float, Float) = min(positiveScale, negativeScale)

        let scaledRgb: [(Float, Float, Float)] = rgb.map { rgb in
            return (rgb - averageLinearRGB) * scale + averageLinearRGB
        }

        let c = scaledRgb.map { rgb in
            return (linearTosRGB(rgb.0) / 51) * 36 + (linearTosRGB(rgb.1) / 51) * 6 + (linearTosRGB(rgb.2) / 51) + 16
        }

        return "\u{1b}[38;5;\(c[1]);48;5;\(c[0])m▄\u{1b}[38;5;\(c[3]);48;5;\(c[2])m▄\u{1b}[38;5;\(c[5]);48;5;\(c[4])m▄\u{1b}[m"
    }
}

