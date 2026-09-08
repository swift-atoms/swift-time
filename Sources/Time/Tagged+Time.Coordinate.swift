public import Tagged

// Coordinate conveniences belong to Time, independently of any clock domain.
// InstantProtocol and ordinary translation are inherited from Tagged.
extension Tagged where Tag: ~Copyable & ~Escapable, Underlying == Time.Coordinate {
    @inlinable
    public init(offset: Swift.Duration) {
        self.init(_unchecked: Time.Coordinate(offset: offset))
    }

    @inlinable
    public var offset: Swift.Duration { underlying.offset }

    @inlinable
    public static var reference: Self { Self(_unchecked: .reference) }

    // InstantProtocol only supplies advancement. Forward subtraction to Coordinate
    // itself so that subtracting Duration's minimum value never negates it first.
    @inlinable
    public static func - (lhs: Self, rhs: Swift.Duration) -> Self {
        Self(_unchecked: lhs.underlying - rhs)
    }

    @inlinable
    public static func -= (lhs: inout Self, rhs: Swift.Duration) { lhs = lhs - rhs }
}
