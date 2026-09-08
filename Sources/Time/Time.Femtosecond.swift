public import Rational

extension Time {
    public struct Femtosecond {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Femtosecond: Swift.Equatable {}

extension Time.Femtosecond: Swift.Hashable {}

extension Time.Femtosecond: Swift.Sendable {}

extension Time.Femtosecond: Swift.Comparable {}
