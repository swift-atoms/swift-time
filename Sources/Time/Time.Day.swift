public import Rational

extension Time {
    /// An exact elapsed quantity measured in days.
    public struct Day {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Day: Swift.Equatable {}

extension Time.Day: Swift.Hashable {}

extension Time.Day: Swift.Sendable {}

#if !hasFeature(Embedded)
extension Time.Day: Swift.Codable {}
#endif
