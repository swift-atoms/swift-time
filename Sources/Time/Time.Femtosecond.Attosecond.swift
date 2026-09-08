extension Time.Femtosecond {

    public struct Attosecond {

        public let value: Int

        public init(_ value: Int) throws(Time.Femtosecond.Attosecond.Error) {
            guard (0...999).contains(value) else {
                throw Error.invalidAttosecond(value)
            }
            self.value = value
        }
    }
}

extension Time.Femtosecond.Attosecond {

    @_spi(Internal)
    public init(unchecked value: Int) {
        self.value = value
    }
}

extension Time.Femtosecond.Attosecond {

    public static func < (lhs: Time.Femtosecond.Attosecond, rhs: Time.Femtosecond.Attosecond) -> Bool {
        lhs.value < rhs.value
    }
}

extension Time.Femtosecond.Attosecond {

    public static let zero = Time.Femtosecond.Attosecond(unchecked: 0)
}

extension Time.Femtosecond.Attosecond: Swift.Sendable {}

extension Time.Femtosecond.Attosecond: Swift.Equatable {}

extension Time.Femtosecond.Attosecond: Swift.Hashable {}

extension Time.Femtosecond.Attosecond: Swift.Comparable {}

#if !hasFeature(Embedded)
extension Time.Femtosecond: Swift.Codable {}
#endif
