public import Rational

extension Time {
    /// An exact elapsed quantity measured in seconds.
    public struct Second {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Second: Equatable {}
extension Time.Second: Hashable {}
extension Time.Second: Sendable {}

extension Time.Second: Comparable {}
#if !hasFeature(Embedded)
extension Time.Second: Codable {}
#endif
