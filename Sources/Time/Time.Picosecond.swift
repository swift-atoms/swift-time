extension Time {

    public struct Picosecond {

        public let value: Int

        public init(_ value: Int) throws(Time.Picosecond.Error) {
            guard (0...999).contains(value) else {
                throw Error.invalidPicosecond(value)
            }
            self.value = value
        }
    }
}

extension Time.Picosecond {

    @_spi(Internal)
    public init(unchecked value: Int) {
        self.value = value
    }
}

extension Time.Picosecond {

    public static func < (lhs: Time.Picosecond, rhs: Time.Picosecond) -> Bool {
        lhs.value < rhs.value
    }
}

extension Time.Picosecond {

    public static let zero = Time.Picosecond(unchecked: 0)
}

extension Time.Picosecond: Sendable {}
extension Time.Picosecond: Equatable {}
extension Time.Picosecond: Hashable {}
extension Time.Picosecond: Comparable {}
