public import Coordinate
internal import Rational

public struct Instant {
    private let coordinate: Time.Coordinate

    public var position: Coordinate::Coordinate<1, Int64> {
        Coordinate::Coordinate(rawValue: secondsSinceUnixEpoch)
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

        Time.Nanosecond((other.coordinate.offset - coordinate.offset).attoseconds / 1_000_000_000)
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
        let result = coordinate.offset.attoseconds.addingReportingOverflow(duration.attoseconds)
        guard !result.overflow else { throw .overflow }
        return try Self(coordinate: Time.Coordinate(offset: .init(attoseconds: result.partialValue)))
    }

    public func duration(exactlyTo other: Self) throws(Instant.Error) -> Duration {

        other.coordinate.offset - coordinate.offset
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
        let result = instant.coordinate.offset.attoseconds.subtractingReportingOverflow(duration.attoseconds)
        precondition(!result.overflow, "Instant subtraction requires a representable coordinate")
        do {
            return try Self(coordinate: Time.Coordinate(offset: .init(attoseconds: result.partialValue)))
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
