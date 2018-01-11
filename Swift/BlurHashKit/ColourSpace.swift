import Foundation

func signPow(_ value: Float, _ exp: Float) -> Float {
	return copysign(pow(abs(value), exp), value)
}

func linearTosRGB(_ value: Float) -> Int {
	let v = max(0, min(1, value))
	if v <= 0.0031308 { return Int(v * 12.92 * 255 + 0.5) }
	else { return Int((1.055 * pow(v, 1 / 2.4) - 0.055) * 255 + 0.5) }
}

func sRGBToLinear<Type: BinaryInteger>(_ value: Type) -> Float {
	let v = Float(Int64(value)) / 255
	if v <= 0.04045 { return v / 12.92 }
	else { return pow((v + 0.055) / 1.055, 2.4) }
}
