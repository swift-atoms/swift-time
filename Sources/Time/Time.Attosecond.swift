public import Rational

extension Time {
    /// An exact elapsed quantity measured in attoseconds.
    public struct Attosecond {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Attosecond: Swift.Equatable {}

extension Time.Attosecond: Swift.Hashable {}

extension Time.Attosecond: Swift.Sendable {}

#if !hasFeature(Embedded)
extension Time.Attosecond: Swift.Codable {}
#endif
