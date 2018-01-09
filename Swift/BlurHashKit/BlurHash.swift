import Foundation

public struct BlurHash {
	public let components: [[(Float, Float, Float)]]

	public var numberOfHorizontalComponents: Int { return components.first!.count }
	public var numberOfVerticalComponents: Int { return components.count }

	public func punch(_ factor: Float) -> BlurHash {
		return BlurHash(components: components.enumerated().map { (y, xComponents) in
			return xComponents.enumerated().map { (x, component) in
				if x == 0 && y == 0 {
					return component
				} else {
					return (component.0 * factor, component.1 * factor, component.2 * factor)
				}
			}
		})
	}
}

public func +(lhs: BlurHash, rhs: BlurHash) throws -> BlurHash {
	return BlurHash(components: paddedZip(lhs.components, rhs.components, [], []).map {
		paddedZip($0.0, $0.1, (0, 0, 0), (0, 0, 0)).map { ($0.0.0 + $0.1.0, $0.0.1 + $0.1.1, $0.0.2 + $0.1.2) }
	})
}

public func -(lhs: BlurHash, rhs: BlurHash) throws -> BlurHash {
	return BlurHash(components: paddedZip(lhs.components, rhs.components, [], []).map {
		paddedZip($0.0, $0.1, (0, 0, 0), (0, 0, 0)).map { ($0.0.0 - $0.1.0, $0.0.1 - $0.1.1, $0.0.2 - $0.1.2) }
	})
}

private func paddedZip<Collection1, Collection2>(_ collection1: Collection1, _ collection2: Collection2, _ padding1: Collection1.Element, _ padding2: Collection2.Element) -> Zip2Sequence<[Collection1.Element], [Collection2.Element]> where Collection1: Collection, Collection2: Collection, Collection1.IndexDistance == Int, Collection2.IndexDistance == Int {
	if collection1.count < collection2.count {
		let padded = collection1 + Array(repeating: padding1, count: collection2.count - collection1.count)
		return zip(padded, Array(collection2))
	} else if collection2.count < collection1.count {
		let padded = collection2 + Array(repeating: padding2, count: collection1.count - collection2.count)
		return zip(Array(collection1), padded)
	} else {
		return zip(Array(collection1), Array(collection2))
	}

}

