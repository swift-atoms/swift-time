extension Time.Millisecond {

    public struct Microsecond {

        public let value: Int

        public init(_ value: Int) throws(Time.Millisecond.Microsecond.Error) {
            guard (0...999).contains(value) else {
                throw Error.invalidMicrosecond(value)
            }
            self.value = value
        }
    }
}

extension Time.Millisecond.Microsecond {

    @_spi(Internal)
    public init(unchecked value: Int) {
        self.value = value
    }
}

extension Time.Millisecond.Microsecond {

    public static func < (lhs: Time.Millisecond.Microsecond, rhs: Time.Millisecond.Microsecond) -> Bool {
        lhs.value < rhs.value
    }
}

extension Time.Millisecond.Microsecond {

    public static let zero = Time.Millisecond.Microsecond(unchecked: 0)
}

extension Time.Millisecond.Microsecond: Sendable {}
extension Time.Millisecond.Microsecond: Equatable {}
extension Time.Millisecond.Microsecond: Hashable {}
extension Time.Millisecond.Microsecond: Comparable {}
