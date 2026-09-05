extension Time {

    public struct Attosecond {

        public let value: Int

        public init(_ value: Int) throws(Time.Attosecond.Error) {
            guard (0...999).contains(value) else {
                throw Error.invalidAttosecond(value)
            }
            self.value = value
        }
    }
}

extension Time.Attosecond {

    @_spi(Internal)
    public init(unchecked value: Int) {
        self.value = value
    }
}

extension Time.Attosecond {

    public static func < (lhs: Time.Attosecond, rhs: Time.Attosecond) -> Bool {
        lhs.value < rhs.value
    }
}

extension Time.Attosecond {

    public static let zero = Time.Attosecond(unchecked: 0)
}

extension Time.Attosecond: Sendable {}
extension Time.Attosecond: Equatable {}
extension Time.Attosecond: Hashable {}
extension Time.Attosecond: Comparable {}
