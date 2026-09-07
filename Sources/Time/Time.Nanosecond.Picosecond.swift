extension Time.Nanosecond {

    public struct Picosecond {

        public let value: Int

        public init(_ value: Int) throws(Time.Nanosecond.Picosecond.Error) {
            guard (0...999).contains(value) else {
                throw Error.invalidPicosecond(value)
            }
            self.value = value
        }
    }
}

extension Time.Nanosecond.Picosecond {

    @_spi(Internal)
    public init(unchecked value: Int) {
        self.value = value
    }
}

extension Time.Nanosecond.Picosecond {

    public static func < (lhs: Time.Nanosecond.Picosecond, rhs: Time.Nanosecond.Picosecond) -> Bool {
        lhs.value < rhs.value
    }
}

extension Time.Nanosecond.Picosecond {

    public static let zero = Time.Nanosecond.Picosecond(unchecked: 0)
}

extension Time.Nanosecond.Picosecond: Swift.Sendable {}

extension Time.Nanosecond.Picosecond: Swift.Equatable {}

extension Time.Nanosecond.Picosecond: Swift.Hashable {}
