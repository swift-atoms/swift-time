public import Rational

extension Time {
    /// An exact elapsed quantity measured in days.
    public struct Day {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Day: Equatable {}
extension Time.Day: Hashable {}
extension Time.Day: Sendable {}

extension Time.Day: Comparable {}
#if !hasFeature(Embedded)
extension Time.Day: Codable {}
#endif
