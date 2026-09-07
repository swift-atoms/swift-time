public import Rational

extension Time {
    /// An exact elapsed quantity measured in seconds.
    public struct Second {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Second: Swift.Equatable {}

extension Time.Second: Swift.Hashable {}

extension Time.Second: Swift.Sendable {}

#if !hasFeature(Embedded)
extension Time.Second: Swift.Codable {}
#endif
