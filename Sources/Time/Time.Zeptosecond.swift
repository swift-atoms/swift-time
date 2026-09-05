extension Time {

    public struct Zeptosecond {

        public let value: Int

        public init(_ value: Int) throws(Time.Zeptosecond.Error) {
            guard (0...999).contains(value) else {
                throw Error.invalidZeptosecond(value)
            }
            self.value = value
        }
    }
}

extension Time.Zeptosecond {

    @_spi(Internal)
    public init(unchecked value: Int) {
        self.value = value
    }
}

extension Time.Zeptosecond {

    public static func < (lhs: Time.Zeptosecond, rhs: Time.Zeptosecond) -> Bool {
        lhs.value < rhs.value
    }
}

extension Time.Zeptosecond {

    public static let zero = Time.Zeptosecond(unchecked: 0)
}

extension Time.Zeptosecond: Sendable {}
extension Time.Zeptosecond: Equatable {}
extension Time.Zeptosecond: Hashable {}
extension Time.Zeptosecond: Comparable {}
