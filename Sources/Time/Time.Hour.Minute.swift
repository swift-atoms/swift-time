extension Time.Hour {

    public struct Minute {

        public let value: Int

        public init(_ value: Int) throws(Time.Hour.Minute.Error) {
            guard (0...59).contains(value) else {
                throw Error.invalidMinute(value)
            }
            self.value = value
        }
    }
}

extension Time.Hour.Minute {

    @_spi(Internal)
    public init(unchecked value: Int) {
        self.value = value
    }
}

extension Time.Hour.Minute {

    public static func < (lhs: Time.Hour.Minute, rhs: Time.Hour.Minute) -> Bool {
        lhs.value < rhs.value
    }
}

extension Time.Hour.Minute {

    public static let zero = Time.Hour.Minute(unchecked: 0)
}

extension Time.Hour.Minute: Sendable {}
extension Time.Hour.Minute: Equatable {}
extension Time.Hour.Minute: Hashable {}
extension Time.Hour.Minute: Comparable {}
