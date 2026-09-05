extension Time {

    public struct Nanosecond {

        public let value: Int

        public init(_ value: Int) throws(Time.Nanosecond.Error) {
            guard (0...999).contains(value) else {
                throw Error.invalidNanosecond(value)
            }
            self.value = value
        }
    }
}

extension Time.Nanosecond {

    @_spi(Internal)
    public init(unchecked value: Int) {
        self.value = value
    }
}

extension Time.Nanosecond {

    public static func < (lhs: Time.Nanosecond, rhs: Time.Nanosecond) -> Bool {
        lhs.value < rhs.value
    }
}

extension Time.Nanosecond {

    public static let zero = Time.Nanosecond(unchecked: 0)
}

extension Time.Nanosecond: Sendable {}
extension Time.Nanosecond: Equatable {}
extension Time.Nanosecond: Hashable {}
extension Time.Nanosecond: Comparable {}
