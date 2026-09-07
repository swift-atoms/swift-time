public import Rational

extension Time {
    public struct Attosecond {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Attosecond: Swift.Equatable {}

extension Time.Attosecond: Swift.Hashable {}

extension Time.Attosecond: Swift.Sendable {}
