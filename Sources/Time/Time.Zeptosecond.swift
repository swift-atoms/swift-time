public import Rational

extension Time {
    public struct Zeptosecond {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Zeptosecond: Swift.Equatable {}

extension Time.Zeptosecond: Swift.Hashable {}

extension Time.Zeptosecond: Swift.Sendable {}
