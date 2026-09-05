public import Rational

extension Time {
    /// An exact elapsed quantity measured in hours.
    public struct Hour {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Hour: Equatable {}
extension Time.Hour: Hashable {}
extension Time.Hour: Sendable {}

extension Time.Hour: Comparable {}
#if !hasFeature(Embedded)
extension Time.Hour: Codable {}
#endif
