extension Time {

    public struct Millisecond {

        public let value: Int

        public init(_ value: Int) throws(Time.Millisecond.Error) {
            guard (0...999).contains(value) else {
                throw Error.invalidMillisecond(value)
            }
            self.value = value
        }
    }
}

extension Time.Millisecond {

    @_spi(Internal)
    public init(unchecked value: Int) {
        self.value = value
    }
}

extension Time.Millisecond {

    public static func < (lhs: Time.Millisecond, rhs: Time.Millisecond) -> Bool {
        lhs.value < rhs.value
    }
}

extension Time.Millisecond {

    public static let zero = Time.Millisecond(unchecked: 0)
}

extension Time.Millisecond: Sendable {}
extension Time.Millisecond: Equatable {}
extension Time.Millisecond: Hashable {}
extension Time.Millisecond: Comparable {}
