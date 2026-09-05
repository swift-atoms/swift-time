public import Rational

extension Time {
    /// An exact elapsed quantity measured in attoseconds.
    public struct Attosecond {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Attosecond: Equatable {}
extension Time.Attosecond: Hashable {}
extension Time.Attosecond: Sendable {}

extension Time.Attosecond: Comparable {}
#if !hasFeature(Embedded)
extension Time.Attosecond: Codable {}
#endif
