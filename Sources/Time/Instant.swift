public import Affine
internal import Rational

/// A Unix-epoch instant with exact nanosecond precision and Int64 seconds.
///
/// Temporal point arithmetic is supplied by Time.Coordinate. This type adds the
/// Unix reference, nanosecond quantization, and the bounded seconds representation.
public struct Instant {
    private let coordinate: Time.Coordinate

    public var position: Affine.Position<Time.Second> {
        Affine.Position(rawValue: secondsSinceUnixEpoch)
    }

    public var nanosecondFraction: Int32 { components.nanoseconds }

    public init(
        secondsSinceUnixEpoch: Int64,
        nanosecondFraction: Int32 = 0
    ) throws(Instant.Error) {
        guard nanosecondFraction >= 0 && nanosecondFraction < 1_000_000_000 else {
            throw .nanosecondOutOfRange(nanosecondFraction)
        }
        self.coordinate = Time.Coordinate(
            offset: .seconds(secondsSinceUnixEpoch) + .nanoseconds(nanosecondFraction)
        )
    }

    private init(coordinate: Time.Coordinate) throws(Instant.Error) {
        let attoseconds = coordinate.offset.attoseconds
        guard attoseconds % 1_000_000_000 == 0 else { throw .precision }
        let seconds = attoseconds / 1_000_000_000_000_000_000
            - (attoseconds % 1_000_000_000_000_000_000 < 0 ? 1 : 0)
        guard Int64(exactly: seconds) != nil else { throw .overflow }
        self.coordinate = coordinate
    }

    private var components: (seconds: Int64, nanoseconds: Int32) {
        let nanoseconds = coordinate.offset.attoseconds / 1_000_000_000
        let remainder = nanoseconds % 1_000_000_000
        let seconds = nanoseconds / 1_000_000_000 - (remainder < 0 ? 1 : 0)
        return (
            Int64(seconds),
            Int32(remainder < 0 ? remainder + 1_000_000_000 : remainder)
        )
    }
}

extension Instant {
    public var secondsSinceUnixEpoch: Int64 { components.seconds }

    public init(secondsSinceUnixEpoch: Int64) {
        self.coordinate = Time.Coordinate(offset: .seconds(secondsSinceUnixEpoch))
    }

    public init(
        _unchecked: Void, secondsSinceUnixEpoch: Int64, nanosecondFraction: Int32
    ) {
        precondition((0..<1_000_000_000).contains(nanosecondFraction))
        self.coordinate = Time.Coordinate(
            offset: .seconds(secondsSinceUnixEpoch) + .nanoseconds(nanosecondFraction)
        )
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.coordinate < rhs.coordinate
    }

    public static func isLessThan(lhs: Self, rhs: Self) -> Bool { lhs < rhs }
}

extension Instant {
    public func displacement(to other: Self) -> Time.Nanosecond {
        // The difference between any two Int64-second coordinates fits Duration.
        Time.Nanosecond(coordinate.duration(to: other.coordinate).attoseconds / 1_000_000_000)
    }

    public func advanced<Unit: Time.Unit>(
        by quantity: Time.Quantity<Unit>
    ) throws(Instant.Error) -> Self {
        let converted: Time.Nanosecond
        do throws(Time.Conversion.Error) {
            converted = try Time.Conversion.quantity(quantity, to: Time.Nanosecond.self)
        } catch { throw .conversion(error) }
        let nanoseconds: Int128
        do throws(Rational.Error) {
            nanoseconds = try converted.value.integer(as: Int128.self)
        } catch {
            if error == .inexact { throw .precision }
            throw .overflow
        }
        let attoseconds = nanoseconds.multipliedReportingOverflow(by: 1_000_000_000)
        guard !attoseconds.overflow else { throw .overflow }
        return try advanced(exactly: Duration(attoseconds: attoseconds.partialValue))
    }

    public func advanced(exactly duration: Duration) throws(Instant.Error) -> Self {
        guard duration.attoseconds % 1_000_000_000 == 0 else { throw .precision }
        let translated: Time.Coordinate
        do { translated = try coordinate.advanced(exactly: duration) }
        catch { throw .overflow }
        return try Self(coordinate: translated)
    }

    public func duration(exactlyTo other: Self) throws(Instant.Error) -> Duration {
        do { return try coordinate.duration(exactlyTo: other.coordinate) }
        catch { throw .overflow }
    }

    public static func add(instant: Self, duration: Duration) -> Self {
        do { return try instant.advanced(exactly: duration) }
        catch { preconditionFailure("Instant addition requires representable exact nanoseconds") }
    }

    public static func subtract(duration: Duration, from instant: Self) -> Self {
        precondition(
            duration.attoseconds % 1_000_000_000 == 0,
            "Instant arithmetic requires exact nanoseconds"
        )
        do {
            return try Self(coordinate: instant.coordinate.retreated(exactlyBy: duration))
        } catch {
            preconditionFailure("Instant subtraction requires a representable coordinate")
        }
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
