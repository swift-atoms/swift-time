public import Rational

extension Time {
    /// An exact elapsed quantity measured in picoseconds.
    public struct Picosecond {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Picosecond: Equatable {}
extension Time.Picosecond: Hashable {}
extension Time.Picosecond: Sendable {}

extension Time.Picosecond: Comparable {}
#if !hasFeature(Embedded)
extension Time.Picosecond: Codable {}
#endif
