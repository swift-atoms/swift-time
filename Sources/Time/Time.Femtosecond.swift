public import Rational

extension Time {
    /// An exact elapsed quantity measured in femtoseconds.
    public struct Femtosecond {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Femtosecond: Equatable {}
extension Time.Femtosecond: Hashable {}
extension Time.Femtosecond: Sendable {}

extension Time.Femtosecond: Comparable {}
#if !hasFeature(Embedded)
extension Time.Femtosecond: Codable {}
#endif
