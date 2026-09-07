public import Rational

extension Time {
    public struct Minute {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Minute: Swift.Equatable {}

extension Time.Minute: Swift.Hashable {}

extension Time.Minute: Swift.Sendable {}
