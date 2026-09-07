public import Rational

extension Time {
    /// An exact elapsed quantity measured in microseconds.
    public struct Microsecond {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Microsecond: Swift.Equatable {}

extension Time.Microsecond: Swift.Hashable {}

extension Time.Microsecond: Swift.Sendable {}

#if !hasFeature(Embedded)
extension Time.Microsecond: Swift.Codable {}
#endif
