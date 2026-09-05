extension Time.Microsecond {

    public struct Nanosecond {

        public let value: Int

        public init(_ value: Int) throws(Time.Microsecond.Nanosecond.Error) {
            guard (0...999).contains(value) else {
                throw Error.invalidNanosecond(value)
            }
            self.value = value
        }
    }
}

extension Time.Microsecond.Nanosecond {

    @_spi(Internal)
    public init(unchecked value: Int) {
        self.value = value
    }
}

extension Time.Microsecond.Nanosecond {

    public static func < (lhs: Time.Microsecond.Nanosecond, rhs: Time.Microsecond.Nanosecond) -> Bool {
        lhs.value < rhs.value
    }
}

extension Time.Microsecond.Nanosecond {

    public static let zero = Time.Microsecond.Nanosecond(unchecked: 0)
}

extension Time.Microsecond.Nanosecond: Sendable {}
extension Time.Microsecond.Nanosecond: Equatable {}
extension Time.Microsecond.Nanosecond: Hashable {}
extension Time.Microsecond.Nanosecond: Comparable {}
