extension Time.Day {

    public struct Hour {

        public let value: Int

        public init(_ value: Int) throws(Time.Day.Hour.Error) {
            guard (0...23).contains(value) else {
                throw Error.invalidHour(value)
            }
            self.value = value
        }
    }
}

extension Time.Day.Hour {

    @_spi(Internal)
    public init(unchecked value: Int) {
        self.value = value
    }
}

extension Time.Day.Hour {

    public static func < (lhs: Time.Day.Hour, rhs: Time.Day.Hour) -> Bool {
        lhs.value < rhs.value
    }
}

extension Time.Day.Hour {

    public static let zero = Time.Day.Hour(unchecked: 0)
}

extension Time.Day.Hour: Swift.Sendable {}

extension Time.Day.Hour: Swift.Equatable {}

extension Time.Day.Hour: Swift.Hashable {}

extension Time.Day.Hour: Swift.Comparable {}
