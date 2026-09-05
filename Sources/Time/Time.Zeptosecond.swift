public import Rational

extension Time {
    /// An exact elapsed quantity measured in zeptoseconds.
    public struct Zeptosecond {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Zeptosecond: Equatable {}
extension Time.Zeptosecond: Hashable {}
extension Time.Zeptosecond: Sendable {}

extension Time.Zeptosecond: Comparable {}
#if !hasFeature(Embedded)
extension Time.Zeptosecond: Codable {}
#endif
