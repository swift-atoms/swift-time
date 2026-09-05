extension Time.Femtosecond {

    public struct Attosecond {

        public let value: Int

        public init(_ value: Int) throws(Time.Femtosecond.Attosecond.Error) {
            guard (0...999).contains(value) else {
                throw Error.invalidAttosecond(value)
            }
            self.value = value
        }
    }
}

extension Time.Femtosecond.Attosecond {

    @_spi(Internal)
    public init(unchecked value: Int) {
        self.value = value
    }
}

extension Time.Femtosecond.Attosecond {

    public static func < (lhs: Time.Femtosecond.Attosecond, rhs: Time.Femtosecond.Attosecond) -> Bool {
        lhs.value < rhs.value
    }
}

extension Time.Femtosecond.Attosecond {

    public static let zero = Time.Femtosecond.Attosecond(unchecked: 0)
}

extension Time.Femtosecond.Attosecond: Sendable {}
extension Time.Femtosecond.Attosecond: Equatable {}
extension Time.Femtosecond.Attosecond: Hashable {}
extension Time.Femtosecond.Attosecond: Comparable {}
