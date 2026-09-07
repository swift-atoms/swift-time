public import Rational

extension Time {
    public struct Microsecond {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Microsecond: Swift.Equatable {}

extension Time.Microsecond: Swift.Hashable {}

extension Time.Microsecond: Swift.Sendable {}
