public import Rational

extension Time {
    public struct Picosecond {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Picosecond: Swift.Equatable {}

extension Time.Picosecond: Swift.Hashable {}

extension Time.Picosecond: Swift.Sendable {}

#if !hasFeature(Embedded)
    extension Time.Picosecond: Swift.Codable {}
#endif

extension Time.Picosecond: Swift.Comparable {}
