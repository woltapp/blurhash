import Foundation

func +(lhs: (Float, Float, Float), rhs: (Float, Float, Float)) -> (Float, Float, Float) {
	return (lhs.0 + rhs.0, lhs.1 + rhs.1, lhs.2 + rhs.2)
}

func -(lhs: (Float, Float, Float), rhs: (Float, Float, Float)) -> (Float, Float, Float) {
	return (lhs.0 - rhs.0, lhs.1 - rhs.1, lhs.2 - rhs.2)
}

func *(lhs: (Float, Float, Float), rhs: Float) -> (Float, Float, Float) {
	return (lhs.0 * rhs, lhs.1 * rhs, lhs.2 * rhs)
}

func *(lhs: Float, rhs: (Float, Float, Float)) -> (Float, Float, Float) {
	return (lhs * rhs.0, lhs * rhs.1, lhs * rhs.2)
}

func /(lhs: (Float, Float, Float), rhs: Float) -> (Float, Float, Float) {
	return (lhs.0 / rhs, lhs.1 / rhs, lhs.2 / rhs)
}

func +=(lhs: inout (Float, Float, Float), rhs: (Float, Float, Float)) {
	lhs = lhs + rhs
}

func -=(lhs: inout (Float, Float, Float), rhs: (Float, Float, Float)) {
	lhs = lhs - rhs
}

func *=(lhs: inout (Float, Float, Float), rhs: Float) {
	lhs = lhs * rhs
}

func /=(lhs: inout (Float, Float, Float), rhs: Float) {
	lhs = lhs / rhs
}
