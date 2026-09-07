public import Rational

extension Time {
    /// An exact elapsed quantity measured in zeptoseconds.
    public struct Zeptosecond {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Zeptosecond: Swift.Equatable {}

extension Time.Zeptosecond: Swift.Hashable {}

extension Time.Zeptosecond: Swift.Sendable {}

#if !hasFeature(Embedded)
extension Time.Zeptosecond: Swift.Codable {}
#endif
