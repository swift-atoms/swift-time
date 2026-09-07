public import Rational

extension Time {
    /// An exact elapsed quantity measured in nanoseconds.
    public struct Nanosecond {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Nanosecond: Swift.Equatable {}

extension Time.Nanosecond: Swift.Hashable {}

extension Time.Nanosecond: Swift.Sendable {}

#if !hasFeature(Embedded)
extension Time.Nanosecond: Swift.Codable {}
#endif
