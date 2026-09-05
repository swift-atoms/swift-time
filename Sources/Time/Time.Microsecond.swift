extension Time {

    public struct Microsecond {

        public let value: Int

        public init(_ value: Int) throws(Time.Microsecond.Error) {
            guard (0...999).contains(value) else {
                throw Error.invalidMicrosecond(value)
            }
            self.value = value
        }
    }
}

extension Time.Microsecond {

    @_spi(Internal)
    public init(unchecked value: Int) {
        self.value = value
    }
}

extension Time.Microsecond {

    public static func < (lhs: Time.Microsecond, rhs: Time.Microsecond) -> Bool {
        lhs.value < rhs.value
    }
}

extension Time.Microsecond {

    public static let zero = Time.Microsecond(unchecked: 0)
}

extension Time.Microsecond: Sendable {}
extension Time.Microsecond: Equatable {}
extension Time.Microsecond: Hashable {}
extension Time.Microsecond: Comparable {}
