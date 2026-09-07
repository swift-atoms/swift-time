public import Rational

extension Time {
    public struct Millisecond {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Millisecond: Swift.Equatable {}

extension Time.Millisecond: Swift.Hashable {}

extension Time.Millisecond: Swift.Sendable {}
