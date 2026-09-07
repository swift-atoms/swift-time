public import Rational

extension Time {
    public struct Second {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Second: Swift.Equatable {}

extension Time.Second: Swift.Hashable {}

extension Time.Second: Swift.Sendable {}
