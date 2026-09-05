extension Time {

    public struct Minute {

        public let value: Int

        public init(_ value: Int) throws(Time.Minute.Error) {
            guard (0...59).contains(value) else {
                throw Error.invalidMinute(value)
            }
            self.value = value
        }
    }
}

extension Time.Minute {

    @_spi(Internal)
    public init(unchecked value: Int) {
        self.value = value
    }
}

extension Time.Minute {

    public static func < (lhs: Time.Minute, rhs: Time.Minute) -> Bool {
        lhs.value < rhs.value
    }
}

extension Time.Minute {

    public static let zero = Time.Minute(unchecked: 0)
}

extension Time.Minute: Sendable {}
extension Time.Minute: Equatable {}
extension Time.Minute: Hashable {}
extension Time.Minute: Comparable {}
