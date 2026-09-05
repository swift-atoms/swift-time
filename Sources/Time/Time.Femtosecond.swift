extension Time {

    public struct Femtosecond {

        public let value: Int

        public init(_ value: Int) throws(Time.Femtosecond.Error) {
            guard (0...999).contains(value) else {
                throw Error.invalidFemtosecond(value)
            }
            self.value = value
        }
    }
}

extension Time.Femtosecond {

    @_spi(Internal)
    public init(unchecked value: Int) {
        self.value = value
    }
}

extension Time.Femtosecond {

    public static func < (lhs: Time.Femtosecond, rhs: Time.Femtosecond) -> Bool {
        lhs.value < rhs.value
    }
}

extension Time.Femtosecond {

    public static let zero = Time.Femtosecond(unchecked: 0)
}

extension Time.Femtosecond: Sendable {}
extension Time.Femtosecond: Equatable {}
extension Time.Femtosecond: Hashable {}
extension Time.Femtosecond: Comparable {}
