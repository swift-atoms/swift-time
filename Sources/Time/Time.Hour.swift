public import Rational

extension Time {
    public struct Hour {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Hour: Swift.Equatable {}

extension Time.Hour: Swift.Hashable {}

extension Time.Hour: Swift.Sendable {}
