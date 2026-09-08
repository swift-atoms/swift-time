public import Rational

extension Time {
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

extension Time.Day: Swift.Comparable {}
