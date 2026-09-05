import Affine
import Tagged
import Difference
import Cardinal
import Foundation
import Testing
import Time
import Rational
import Ratio

@Suite struct Exact {
    @Test func `quantity values preserve ordering arithmetic and rational encoding`() throws {
        let fraction = try Rational(numerator: 3, denominator: 2, polarity: .negative)
        let quantity = Time.Hour(fraction)
        #expect(quantity < Time.Hour.zero)
        #expect(try quantity - quantity == .zero)
        let encoded = try JSONEncoder().encode(quantity)
        #expect(try JSONDecoder().decode(Time.Hour.self, from: encoded) == quantity)
        #expect(try JSONDecoder().decode(Rational.self, from: encoded) == fraction)
    }

    @Test func `quantities preserve fractional and signed conversions`() throws {
        let hours = try Time.Conversion.quantity(Time.Minute(90), to: Time.Hour.self)
        #expect(hours.value == (try Rational(numerator: 3, denominator: 2)))
        let minutes = try Time.Conversion.quantity(Time.Second(-1), to: Time.Minute.self)
        #expect(minutes.value == (try Rational(numerator: 1, denominator: 60, polarity: .negative)))
        #expect(try Time.Conversion.quantity(hours, to: Time.Minute.self) == Time.Minute(90))
    }

    @Test func `count and offset conversions preserve roles and report inexactness`() throws {
        let seconds = try Time.Conversion.count(Time.Minute.count(Cardinal(2 as UInt)), to: Time.Second.self)
        #expect(seconds.underlying == Cardinal(120 as UInt))
        let offset = try Time.Conversion.offset(Time.Minute.offset(Difference(-2)), to: Time.Second.self)
        #expect(offset.underlying == Difference(-120))
        #expect(throws: Ratio::Failure.inexact) {
            try Time.Conversion.offset(Time.Second.offset(Difference(1)), to: Time.Minute.self)
        }
        let sum = try Time.Second(2) + Time.Second(3)
        #expect(sum == Time.Second(5))
    }

    @Test func `every fractional unit converts exactly in both directions`() throws {
        func roundTrip<Unit: Time.Unit>(_ unit: Unit.Type) throws {
            let quantity = Time.Second(-123)
            let converted = try Time.Conversion.quantity(quantity, to: unit)
            #expect(try Time.Conversion.quantity(converted, to: Time.Second.self) == quantity)
        }
        try roundTrip(Time.Millisecond.self)
        try roundTrip(Time.Microsecond.self)
        try roundTrip(Time.Nanosecond.self)
        try roundTrip(Time.Picosecond.self)
        try roundTrip(Time.Femtosecond.self)
        try roundTrip(Time.Attosecond.self)
        try roundTrip(Time.Zeptosecond.self)
        try roundTrip(Time.Yoctosecond.self)
        let yoctoseconds = try Time.Conversion.quantity(Time.Second(1), to: Time.Yoctosecond.self)
        #expect(yoctoseconds.value.numerator == 1_000_000_000_000_000_000_000_000)
        #expect(yoctoseconds.value.denominator == 1)
    }

    @Test(arguments: [Int.min, -86_401, -1, 0, 1, 86_401, Int.max])
    func `clock decomposition preserves negative carry at every bound`(seconds: Int) {
        let parts = Time.Conversion.components(fromSeconds: seconds)
        let remainder = Time.Conversion.seconds(hour: parts.hour, minute: parts.minute, second: parts.second)
        #expect(Int128(parts.days) * Int128(Time.Conversion.secondsPerDay) + Int128(remainder) == Int128(seconds))
        #expect((0..<Time.Conversion.secondsPerDay).contains(remainder))
    }

    @Test func `instant preserves the complete endpoint displacement`() throws {
        let first = Instant(secondsSinceUnixEpoch: .min)
        let last = try Instant(secondsSinceUnixEpoch: .max, nanosecondFraction: 999_999_999)
        let displacement = first.displacement(to: last)
        #expect(displacement.value.numerator == UInt128(UInt64.max) * 1_000_000_000 + 999_999_999)
        #expect(try first.advanced(by: displacement) == last)
        #expect(try last.advanced(by: last.displacement(to: first)) == first)
        let duration = try first.duration(exactlyTo: last)
        #expect(duration.attoseconds == Int128(UInt64.max) * 1_000_000_000_000_000_000 + 999_999_999_000_000_000)
        #expect(try first.advanced(exactly: duration) == last)
        #expect(try last.advanced(exactly: first.duration(exactlyTo: last) * -1) == first)
        #expect(last - duration == first)
        #expect(first + duration == last)
        #expect(throws: Instant.Error.overflow) { try first.advanced(by: Time.Nanosecond(-1)) }
        #expect(throws: Instant.Error.overflow) { try last.advanced(by: Time.Nanosecond(1)) }
    }

    @Test func `instant rejects subnanosecond precision rather than truncating`() throws {
        let origin = Instant(secondsSinceUnixEpoch: 0)
        #expect(throws: Instant.Error.precision) {
            try origin.advanced(exactly: Duration(secondsComponent: 0, attosecondsComponent: 1))
        }
        #expect(throws: Instant.Error.precision) {
            try origin.advanced(by: Time.Picosecond(1))
        }
        #expect(try origin.advanced(by: Time.Picosecond(1000)).nanosecondFraction == 1)
        #expect(try origin.advanced(by: Time.Nanosecond(-1)) ==
            Instant(secondsSinceUnixEpoch: -1, nanosecondFraction: 999_999_999))
        let picosecond = Duration.seconds(0.000000000001)
        #expect(picosecond.attoseconds == 1_000_000)
        #expect(throws: Instant.Error.precision) {
            try origin.advanced(exactly: picosecond)
        }
    }

    @Test func `full native duration range produces checked precision or coordinate errors`() throws {
        let origin = Instant(secondsSinceUnixEpoch: 0)
        for attoseconds in [Int128.min, .max] {
            #expect(throws: Instant.Error.precision) {
                try origin.advanced(exactly: Duration(attoseconds: attoseconds))
            }
            let exactNanoseconds = attoseconds / 1_000_000_000 * 1_000_000_000
            #expect(throws: Instant.Error.overflow) {
                try origin.advanced(exactly: Duration(attoseconds: exactNanoseconds))
            }
        }
    }

    @Test func `instant decoding establishes the fraction invariant`() throws {
        for fraction in [-1, 1_000_000_000, Int(Int32.max)] {
            let bytes = Data("{\"secondsSinceUnixEpoch\":0,\"nanosecondFraction\":\(fraction)}".utf8)
            #expect(throws: DecodingError.self) { try JSONDecoder().decode(Instant.self, from: bytes) }
        }
        let value = try Instant(secondsSinceUnixEpoch: -123, nanosecondFraction: 999_999_999)
        #expect(try JSONDecoder().decode(Instant.self, from: JSONEncoder().encode(value)) == value)
    }

    @Test func `fixed zone formatting retains negative subminute offsets`() throws {
        #expect(Time.Zone.seconds(-1).description == "-00:00:01")
        #expect(Time.Zone.seconds(-30 * 60).description == "-00:30")
        #expect(Time.Zone.seconds(30).description == "+00:00:30")
        #expect(try Time.Zone.hours(0, minutes: -30).description == "-00:30")
        #expect(throws: Difference.Error.overflow) { try Time.Zone.hours(Int.max) }
        #expect(Time.Zone.utc.description == "+00:00")
        #expect(String(describing: Time.Zone.seconds(-1)) == "-00:00:01")
    }

    @Test func `custom unit scales must be positive and nonzero`() throws {
        struct Zero: Time.Unit {
            let value: Rational
            init(_ value: Rational) { self.value = value }
            static var seconds: Ratio<Zero, Time.Second> { .zero }
        }
        struct Negative: Time.Unit {
            let value: Rational
            init(_ value: Rational) { self.value = value }
            static var seconds: Ratio<Negative, Time.Second> { Ratio<Negative, Time.Second>(Int(-1)) }
        }
        #expect(throws: Ratio::Failure.zeroFactor) {
            try Time.Conversion.quantity(Zero(1), to: Time.Second.self)
        }
        #expect(throws: Ratio::Failure.negativeFactor) {
            try Time.Conversion.quantity(Time.Second(1), to: Negative.self)
        }
    }

    @Test func `epoch converts exact tagged displacements`() throws {
        let origin = try Instant(secondsSinceUnixEpoch: -1, nanosecondFraction: 999_999_999)
        let epoch = Time.Epoch(referenceDate: origin)
        let next = try epoch.instant(after: Time.Nanosecond(2))
        #expect(next.secondsSinceUnixEpoch == 0)
        #expect(next.nanosecondFraction == 1)
        #expect(epoch.displacement(to: next) == Time.Nanosecond(2))
    }

    @Test func `timeout millisecond projection saturates without intermediate overflow`() {
        #expect(Instant.milliseconds(from: .seconds(Int64.max)) == CInt.max)
        #expect(Instant.milliseconds(from: .seconds(Int64.min)) == CInt.min)
        #expect(Instant.milliseconds(from: Duration(attoseconds: .max)) == CInt.max)
        #expect(Instant.milliseconds(from: Duration(attoseconds: .min)) == CInt.min)
    }

    @Test func `approximate duration projections accept the full native range`() {
        let maximum = Duration(attoseconds: .max)
        let minimum = Duration(attoseconds: .min)
        #expect(maximum.inSeconds == Double(Int128.max) / 1_000_000_000_000_000_000)
        #expect(minimum.inSeconds == Double(Int128.min) / 1_000_000_000_000_000_000)
        #expect(maximum.inSeconds > Double(Int64.max))
        #expect(minimum.inSeconds < Double(Int64.min))
    }
}
