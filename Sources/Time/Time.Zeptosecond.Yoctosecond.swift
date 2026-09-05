extension Time.Zeptosecond {

    public struct Yoctosecond {

        public let value: Int

        public init(_ value: Int) throws(Time.Zeptosecond.Yoctosecond.Error) {
            guard (0...999).contains(value) else {
                throw Error.invalidYoctosecond(value)
            }
            self.value = value
        }
    }
}

extension Time.Zeptosecond.Yoctosecond {

    @_spi(Internal)
    public init(unchecked value: Int) {
        self.value = value
    }
}

extension Time.Zeptosecond.Yoctosecond {

    public static func < (lhs: Time.Zeptosecond.Yoctosecond, rhs: Time.Zeptosecond.Yoctosecond) -> Bool {
        lhs.value < rhs.value
    }
}

extension Time.Zeptosecond.Yoctosecond {

    public static let zero = Time.Zeptosecond.Yoctosecond(unchecked: 0)
}

extension Time.Zeptosecond.Yoctosecond: Sendable {}
extension Time.Zeptosecond.Yoctosecond: Equatable {}
extension Time.Zeptosecond.Yoctosecond: Hashable {}
extension Time.Zeptosecond.Yoctosecond: Comparable {}
