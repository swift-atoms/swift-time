extension Time.Attosecond {

    public struct Zeptosecond {

        public let value: Int

        public init(_ value: Int) throws(Time.Attosecond.Zeptosecond.Error) {
            guard (0...999).contains(value) else {
                throw Error.invalidZeptosecond(value)
            }
            self.value = value
        }
    }
}

extension Time.Attosecond.Zeptosecond {

    @_spi(Internal)
    public init(unchecked value: Int) {
        self.value = value
    }
}

extension Time.Attosecond.Zeptosecond {

    public static func < (lhs: Time.Attosecond.Zeptosecond, rhs: Time.Attosecond.Zeptosecond) -> Bool {
        lhs.value < rhs.value
    }
}

extension Time.Attosecond.Zeptosecond {

    public static let zero = Time.Attosecond.Zeptosecond(unchecked: 0)
}

extension Time.Attosecond.Zeptosecond: Sendable {}
extension Time.Attosecond.Zeptosecond: Equatable {}
extension Time.Attosecond.Zeptosecond: Hashable {}
extension Time.Attosecond.Zeptosecond: Comparable {}
