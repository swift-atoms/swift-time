extension Time {

    public struct Hour {

        public let value: Int

        public init(_ value: Int) throws(Time.Hour.Error) {
            guard (0...23).contains(value) else {
                throw Error.invalidHour(value)
            }
            self.value = value
        }
    }
}

extension Time.Hour {

    @_spi(Internal)
    public init(unchecked value: Int) {
        self.value = value
    }
}

extension Time.Hour {

    public static func < (lhs: Time.Hour, rhs: Time.Hour) -> Bool {
        lhs.value < rhs.value
    }
}

extension Time.Hour {

    public static let zero = Time.Hour(unchecked: 0)
}

extension Time.Hour: Sendable {}
extension Time.Hour: Equatable {}
extension Time.Hour: Hashable {}
extension Time.Hour: Comparable {}
