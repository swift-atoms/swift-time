public import Rational

extension Time {
    /// An exact elapsed quantity measured in nanoseconds.
    public struct Nanosecond {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Nanosecond: Equatable {}
extension Time.Nanosecond: Hashable {}
extension Time.Nanosecond: Sendable {}

extension Time.Nanosecond: Comparable {}
#if !hasFeature(Embedded)
extension Time.Nanosecond: Codable {}
#endif
