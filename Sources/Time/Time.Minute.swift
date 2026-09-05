public import Rational

extension Time {
    /// An exact elapsed quantity measured in minutes.
    public struct Minute {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Minute: Equatable {}
extension Time.Minute: Hashable {}
extension Time.Minute: Sendable {}

extension Time.Minute: Comparable {}
#if !hasFeature(Embedded)
extension Time.Minute: Codable {}
#endif
