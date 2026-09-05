public import Rational

extension Time {
    /// An exact elapsed quantity measured in yoctoseconds.
    public struct Yoctosecond {
        public let value: Rational

        public init(_ value: Rational) { self.value = value }
    }
}

extension Time.Yoctosecond: Equatable {}
extension Time.Yoctosecond: Hashable {}
extension Time.Yoctosecond: Sendable {}

extension Time.Yoctosecond: Comparable {}
#if !hasFeature(Embedded)
extension Time.Yoctosecond: Codable {}
#endif
