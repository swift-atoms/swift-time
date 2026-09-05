public import Rational

extension Time {
    /// An exact elapsed quantity measured in microseconds.
    public struct Microsecond {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Microsecond: Equatable {}
extension Time.Microsecond: Hashable {}
extension Time.Microsecond: Sendable {}

extension Time.Microsecond: Comparable {}
#if !hasFeature(Embedded)
extension Time.Microsecond: Codable {}
#endif
