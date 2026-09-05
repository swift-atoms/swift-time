extension Time.Second {

    public struct Millisecond {

        public let value: Int

        public init(_ value: Int) throws(Time.Second.Millisecond.Error) {
            guard (0...999).contains(value) else {
                throw Error.invalidMillisecond(value)
            }
            self.value = value
        }
    }
}

extension Time.Second.Millisecond {

    @_spi(Internal)
    public init(unchecked value: Int) {
        self.value = value
    }
}

extension Time.Second.Millisecond {

    public static func < (lhs: Time.Second.Millisecond, rhs: Time.Second.Millisecond) -> Bool {
        lhs.value < rhs.value
    }
}

extension Time.Second.Millisecond {

    public static let zero = Time.Second.Millisecond(unchecked: 0)
}

extension Time.Second.Millisecond: Sendable {}
extension Time.Second.Millisecond: Equatable {}
extension Time.Second.Millisecond: Hashable {}
extension Time.Second.Millisecond: Comparable {}
