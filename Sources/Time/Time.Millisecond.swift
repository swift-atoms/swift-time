public import Rational

extension Time {
    /// An exact elapsed quantity measured in milliseconds.
    public struct Millisecond {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Millisecond: Swift.Equatable {}

extension Time.Millisecond: Swift.Hashable {}

extension Time.Millisecond: Swift.Sendable {}

#if !hasFeature(Embedded)
extension Time.Millisecond: Swift.Codable {}
#endif
