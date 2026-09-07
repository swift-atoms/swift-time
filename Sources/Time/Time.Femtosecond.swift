public import Rational

extension Time {
    /// An exact elapsed quantity measured in femtoseconds.
    public struct Femtosecond {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Femtosecond: Swift.Equatable {}

extension Time.Femtosecond: Swift.Hashable {}

extension Time.Femtosecond: Swift.Sendable {}

#if !hasFeature(Embedded)
extension Time.Femtosecond: Swift.Codable {}
#endif
