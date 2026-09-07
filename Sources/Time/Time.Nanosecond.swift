public import Rational

extension Time {
    public struct Nanosecond {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Nanosecond: Swift.Equatable {}

extension Time.Nanosecond: Swift.Hashable {}

extension Time.Nanosecond: Swift.Sendable {}
