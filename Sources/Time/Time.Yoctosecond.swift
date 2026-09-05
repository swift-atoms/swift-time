extension Time {

    public struct Yoctosecond {

        public let value: Int

        public init(_ value: Int) throws(Time.Yoctosecond.Error) {
            guard (0...999).contains(value) else {
                throw Error.invalidYoctosecond(value)
            }
            self.value = value
        }
    }
}

extension Time.Yoctosecond {

    @_spi(Internal)
    public init(unchecked value: Int) {
        self.value = value
    }
}

extension Time.Yoctosecond {

    public static func < (lhs: Time.Yoctosecond, rhs: Time.Yoctosecond) -> Bool {
        lhs.value < rhs.value
    }
}

extension Time.Yoctosecond {

    public static let zero = Time.Yoctosecond(unchecked: 0)
}

extension Time.Yoctosecond: Sendable {}
extension Time.Yoctosecond: Equatable {}
extension Time.Yoctosecond: Hashable {}
extension Time.Yoctosecond: Comparable {}
