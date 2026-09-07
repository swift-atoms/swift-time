public import Rational

extension Time {
    public struct Yoctosecond {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Yoctosecond: Swift.Equatable {}

extension Time.Yoctosecond: Swift.Hashable {}

extension Time.Yoctosecond: Swift.Sendable {}
