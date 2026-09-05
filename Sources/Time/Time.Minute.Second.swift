extension Time.Minute {

    public struct Second {

        public let value: Int

        public init(_ value: Int) throws(Time.Minute.Second.Error) {
            guard (0...60).contains(value) else {
                throw Error.invalidSecond(value)
            }
            self.value = value
        }
    }
}

extension Time.Minute.Second {

    @_spi(Internal)
    public init(unchecked value: Int) {
        self.value = value
    }
}

extension Time.Minute.Second {

    public static func < (lhs: Time.Minute.Second, rhs: Time.Minute.Second) -> Bool {
        lhs.value < rhs.value
    }
}

extension Time.Minute.Second {

    public static let zero = Time.Minute.Second(unchecked: 0)
}

extension Time.Minute.Second: Sendable {}
extension Time.Minute.Second: Equatable {}
extension Time.Minute.Second: Hashable {}
extension Time.Minute.Second: Comparable {}
