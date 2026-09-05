extension Time {

    public struct Second {

        public let value: Int

        public init(_ value: Int) throws(Time.Second.Error) {
            guard (0...60).contains(value) else {
                throw Error.invalidSecond(value)
            }
            self.value = value
        }
    }
}

extension Time.Second {

    @_spi(Internal)
    public init(unchecked value: Int) {
        self.value = value
    }
}

extension Time.Second {

    public static func < (lhs: Time.Second, rhs: Time.Second) -> Bool {
        lhs.value < rhs.value
    }
}

extension Time.Second {

    public static let zero = Time.Second(unchecked: 0)
}

extension Time.Second: Sendable {}
extension Time.Second: Equatable {}
extension Time.Second: Hashable {}
extension Time.Second: Comparable {}
