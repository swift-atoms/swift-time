public import Rational

extension Time {
    /// An exact elapsed quantity measured in milliseconds.
    public struct Millisecond {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Millisecond: Equatable {}
extension Time.Millisecond: Hashable {}
extension Time.Millisecond: Sendable {}

extension Time.Millisecond: Comparable {}
#if !hasFeature(Embedded)
extension Time.Millisecond: Codable {}
#endif
