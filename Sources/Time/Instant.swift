public import Affine
internal import Rational
internal import Ratio
internal import Division
internal import Addition

/// A Unix timeline position with an exact nanosecond fraction.
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
    /// The exact separation, including the full endpoint-to-endpoint range.
    public func displacement(to other: Self) -> Time.Nanosecond {
        let seconds = Int128(other.secondsSinceUnixEpoch) - Int128(secondsSinceUnixEpoch)
        let fraction = Int128(other.nanosecondFraction) - Int128(nanosecondFraction)
        return Time.Nanosecond(seconds * 1_000_000_000 + fraction)
    }

    /// Rejects fractional nanoseconds and out-of-range timeline coordinates.
    public func advanced<Unit: Time.Unit>(
        by quantity: Time.Quantity<Unit>
    ) throws(Instant.Error) -> Self {
        let converted: Time.Nanosecond
        do throws(Ratio::Failure) {
            converted = try Time.Conversion.quantity(quantity, to: Time.Nanosecond.self)
        } catch { throw .conversion(error) }
        let nanoseconds: Int128
        do throws(Rational.Error) {
            nanoseconds = try converted.value.integer()
        } catch {
            if error == .inexact { throw .precision }
            throw .overflow
        }
        // Split before adding so even an Int128-sized displacement cannot overflow
        // a temporary sum with the existing coordinate.
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

    /// Swift.Duration may represent subnanosecond values; these are never truncated.
    public func advanced(exactly duration: Duration) throws(Instant.Error) -> Self {
        let attoseconds = duration.attoseconds
        guard attoseconds % 1_000_000_000 == 0 else { throw .precision }
        return try advanced(by: Time.Nanosecond(attoseconds / 1_000_000_000))
    }

    public func duration(exactlyTo other: Self) throws(Instant.Error) -> Duration {
        let nanoseconds: Int128
        do { nanoseconds = try displacement(to: other).value.integer() }
        catch { throw .overflow }
        // Even the full Int64 seconds range with both endpoint fractions spans
        // less than 2^65 seconds. Its attoseconds fit Swift.Duration's Int128.
        return Duration(attoseconds: nanoseconds * 1_000_000_000)
    }

    public static func add(instant: Self, duration: Duration) -> Self {
        do { return try instant.advanced(exactly: duration) }
        catch { preconditionFailure("Instant addition requires representable exact nanoseconds") }
    }

    public static func subtract(duration: Duration, from instant: Self) -> Self {
        let attoseconds = duration.attoseconds
        precondition(attoseconds % 1_000_000_000 == 0, "Instant arithmetic requires exact nanoseconds")
        // Division first makes negation safe even for Duration's Int128 minimum.
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

extension Instant: InstantProtocol {
    public typealias Duration = Swift.Duration
    public func advanced(by duration: Duration) -> Self { self + duration }
    public func duration(to other: Self) -> Duration { other - self }
}

extension Instant: Sendable {}
extension Instant: Equatable {}
extension Instant: Hashable {}
extension Instant: Comparable {}

#if !hasFeature(Embedded)
    extension Instant: Codable {
        private enum CodingKeys: String, CodingKey {
            case secondsSinceUnixEpoch
            case nanosecondFraction
        }

        public init(from decoder: any Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            let seconds = try values.decode(Int64.self, forKey: .secondsSinceUnixEpoch)
            let fraction = try values.decode(Int32.self, forKey: .nanosecondFraction)
            do { try self.init(secondsSinceUnixEpoch: seconds, nanosecondFraction: fraction) }
            catch {
                throw DecodingError.dataCorruptedError(
                    forKey: .nanosecondFraction, in: values,
                    debugDescription: "An Instant fraction must be in 0..<1,000,000,000"
                )
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var values = encoder.container(keyedBy: CodingKeys.self)
            try values.encode(secondsSinceUnixEpoch, forKey: .secondsSinceUnixEpoch)
            try values.encode(nanosecondFraction, forKey: .nanosecondFraction)
        }
    }
#endif

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
