public import Rational

extension Time {
    /// An exact elapsed quantity measured in hours.
    public struct Hour {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Hour: Swift.Equatable {}

extension Time.Hour: Swift.Hashable {}

extension Time.Hour: Swift.Sendable {}

#if !hasFeature(Embedded)
extension Time.Hour: Swift.Codable {}
#endif
