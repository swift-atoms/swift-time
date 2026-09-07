extension Time.Picosecond {

    public struct Femtosecond {

        public let value: Int

        public init(_ value: Int) throws(Time.Picosecond.Femtosecond.Error) {
            guard (0...999).contains(value) else {
                throw Error.invalidFemtosecond(value)
            }
            self.value = value
        }
    }
}

extension Time.Picosecond.Femtosecond {

    @_spi(Internal)
    public init(unchecked value: Int) {
        self.value = value
    }
}

extension Time.Picosecond.Femtosecond {

    public static func < (lhs: Time.Picosecond.Femtosecond, rhs: Time.Picosecond.Femtosecond) -> Bool {
        lhs.value < rhs.value
    }
}

extension Time.Picosecond.Femtosecond {

    public static let zero = Time.Picosecond.Femtosecond(unchecked: 0)
}

extension Time.Picosecond.Femtosecond: Swift.Sendable {}

extension Time.Picosecond.Femtosecond: Swift.Equatable {}

extension Time.Picosecond.Femtosecond: Swift.Hashable {}
