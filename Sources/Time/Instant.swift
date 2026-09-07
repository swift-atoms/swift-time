public import Affine
internal import Rational
internal import Ratio
internal import Division
internal import Addition

public struct Instant {
    public let position: Affine.Position<Time.Second>
    public let nanosecondFraction: Int32

    public init(
        secondsSinceUnixEpoch: Int64,
        nanosecondFraction: Int32 = 0
    ) throws(Instant.Error) {
        guard nanosecondFraction >= 0 && nanosecondFraction < 1_000_000_000 else {
            throw .nanosecondOutOfRange(nanosecondFraction)
        }
        self.position = Affine.Position(rawValue: secondsSinceUnixEpoch)
        self.nanosecondFraction = nanosecondFraction
    }
}

extension Instant {
    public var secondsSinceUnixEpoch: Int64 { position.rawValue }

    public init(secondsSinceUnixEpoch: Int64) {
        self.position = Affine.Position(rawValue: secondsSinceUnixEpoch)
        self.nanosecondFraction = 0
    }

    public init(
        _unchecked: Void, secondsSinceUnixEpoch: Int64, nanosecondFraction: Int32
    ) {
        precondition((0..<1_000_000_000).contains(nanosecondFraction))
        self.position = Affine.Position(rawValue: secondsSinceUnixEpoch)
        self.nanosecondFraction = nanosecondFraction
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.position == rhs.position
            ? lhs.nanosecondFraction < rhs.nanosecondFraction
            : lhs.position < rhs.position
    }

    public static func isLessThan(lhs: Self, rhs: Self) -> Bool { lhs < rhs }
}

extension Instant {
    public func displacement(to other: Self) -> Time.Nanosecond {
        let seconds = Int128(other.secondsSinceUnixEpoch) - Int128(secondsSinceUnixEpoch)
        let fraction = Int128(other.nanosecondFraction) - Int128(nanosecondFraction)
        return Time.Nanosecond(seconds * 1_000_000_000 + fraction)
    }

    public func advanced<Unit: Time.Unit>(
        by quantity: Time.Quantity<Unit>
    ) throws(Instant.Error) -> Self {
        let converted: Time.Nanosecond
        do throws(Ratio::Failure) {
            converted = try Time.Conversion.quantity(quantity, to: Time.Nanosecond.self)
        } catch { throw .conversion(error) }
        let nanoseconds: Int128
        do throws(Rational.Error) {
            nanoseconds = try converted.value.integer(as: Int128.self)
        } catch {
            if error == .inexact { throw .precision }
            throw .overflow
        }
        let split: (quotient: Int128, remainder: Int128)
        do { split = try Division.euclidean(nanoseconds, by: 1_000_000_000) }
        catch { throw .overflow }
        let fraction = Int128(nanosecondFraction) + split.remainder
        let carry = fraction / 1_000_000_000
        let base = Int128(secondsSinceUnixEpoch)
        let sum = Addition.reporting(base, split.quotient)
        guard !sum.overflow else { throw .overflow }
        let carried = Addition.reporting(sum.value, carry)
        guard !carried.overflow, let seconds = Int64(exactly: carried.value) else {
            throw .overflow
        }
        return Self(
            _unchecked: (), secondsSinceUnixEpoch: seconds,
            nanosecondFraction: Int32(fraction % 1_000_000_000)
        )
    }

    public func advanced(exactly duration: Duration) throws(Instant.Error) -> Self {
        let attoseconds = duration.attoseconds
        guard attoseconds % 1_000_000_000 == 0 else { throw .precision }
        return try advanced(by: Time.Nanosecond(attoseconds / 1_000_000_000))
    }

    public func duration(exactlyTo other: Self) throws(Instant.Error) -> Duration {
        let nanoseconds: Int128
        do { nanoseconds = try displacement(to: other).value.integer(as: Int128.self) }
        catch { throw .overflow }
        return Duration(attoseconds: nanoseconds * 1_000_000_000)
    }

    public static func add(instant: Self, duration: Duration) -> Self {
        do { return try instant.advanced(exactly: duration) }
        catch { preconditionFailure("Instant addition requires representable exact nanoseconds") }
    }

    public static func subtract(duration: Duration, from instant: Self) -> Self {
        let attoseconds = duration.attoseconds
        precondition(attoseconds % 1_000_000_000 == 0, "Instant arithmetic requires exact nanoseconds")
        let displacement = -(attoseconds / 1_000_000_000)
        do { return try instant.advanced(by: Time.Nanosecond(displacement)) }
        catch { preconditionFailure("Instant subtraction requires a representable coordinate") }
    }

    public static func duration(from: Self, to: Self) -> Duration {
        do { return try from.duration(exactlyTo: to) }
        catch { preconditionFailure("The displacement does not fit Swift.Duration") }
    }

    public static func + (lhs: Self, rhs: Duration) -> Self { add(instant: lhs, duration: rhs) }
    public static func - (lhs: Self, rhs: Duration) -> Self { subtract(duration: rhs, from: lhs) }
    public static func - (lhs: Self, rhs: Self) -> Duration { duration(from: rhs, to: lhs) }
}


extension Instant: Swift.Sendable {}

extension Instant: Swift.Equatable {}

extension Instant: Swift.Hashable {}

extension Instant {
    public static func + <Unit: Time.Unit>(
        lhs: Instant, rhs: Unit
    ) throws(Instant.Error) -> Instant {
        try lhs.advanced(by: rhs)
    }

    public static func - <Unit: Time.Unit>(
        lhs: Instant, rhs: Unit
    ) throws(Instant.Error) -> Instant {
        try lhs.advanced(by: -rhs)
    }
}
