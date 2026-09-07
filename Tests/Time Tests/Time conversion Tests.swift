import Cardinal
import Difference
import Magnitude
import Polarity
import Rational
import Ratio
import Testing
import Time

@Suite struct `Temporal conversions retain their own failure domain` {
    private struct Zero: Time.Unit {
        let value: Rational
        init(_ value: Rational) { self.value = value }
        static var seconds: Ratio<Self, Time.Second> { .zero }
    }

    private struct Negative: Time.Unit {
        let value: Rational
        init(_ value: Rational) { self.value = value }
        static var seconds: Ratio<Self, Time.Second> { Ratio(Int(-1)) }
    }

    private struct HalfSecond: Time.Unit {
        let value: Rational
        init(_ value: Rational) { self.value = value }
        static var seconds: Ratio<Self, Time.Second> {
            Ratio(try! Rational(numerator: 1, denominator: 2))
        }
    }

    private struct Large: Time.Unit {
        let value: Rational
        init(_ value: Rational) { self.value = value }
        static var seconds: Ratio<Self, Time.Second> { Ratio(Rational(Int128.max)) }
    }

    @Test func `both conversion directions reject zero and negative unit scales`() {
        #expect(throws: Time.Conversion.Error.zeroFactor) {
            try Time.Conversion.ratio(from: Zero.self, to: Time.Second.self)
        }
        #expect(throws: Time.Conversion.Error.zeroFactor) {
            try Time.Conversion.ratio(from: Time.Second.self, to: Zero.self)
        }
        #expect(throws: Time.Conversion.Error.negativeFactor) {
            try Negative(1).converted(to: Time.Second.self)
        }
        #expect(throws: Time.Conversion.Error.negativeFactor) {
            try Time.Second(1).converted(to: Negative.self)
        }
    }

    @Test func `zero counts and offsets still require valid temporal units`() {
        #expect(throws: Time.Conversion.Error.zeroFactor) {
            try Time.Conversion.count(Zero.count(.zero), to: Time.Second.self)
        }
        #expect(throws: Time.Conversion.Error.negativeFactor) {
            try Time.Conversion.count(Time.Second.count(.zero), to: Negative.self)
        }
        #expect(throws: Time.Conversion.Error.negativeFactor) {
            try Time.Conversion.offset(Negative.offset(.zero), to: Time.Second.self)
        }
        #expect(throws: Time.Conversion.Error.zeroFactor) {
            try Time.Conversion.offset(Time.Second.offset(.zero), to: Zero.self)
        }
    }

    @Test func `fractional scales preserve rational quantities and reject inexact discrete results`() throws {
        let seconds = try HalfSecond(3).converted(to: Time.Second.self)
        #expect(seconds.value == (try Rational(numerator: 3, denominator: 2)))
        #expect(try seconds.converted(to: HalfSecond.self).value == 3)
        #expect(throws: Time.Conversion.Error.inexact) {
            try Time.Conversion.count(HalfSecond.count(Cardinal(3 as UInt)), to: Time.Second.self)
        }
        #expect(throws: Time.Conversion.Error.inexact) {
            try Time.Conversion.offset(HalfSecond.offset(Difference(-3)), to: Time.Second.self)
        }
        #expect(try Time.Conversion.count(HalfSecond.count(Cardinal(4 as UInt)), to: Time.Second.self).underlying == 2)
        #expect(try Time.Conversion.offset(HalfSecond.offset(Difference(-4)), to: Time.Second.self).underlying == -2)
    }

    @Test func `count conversion reports overflow at the fixed storage boundary`() throws {
        let maximum = Cardinal(UInt.max)
        let count = Time.Minute.count(maximum)
        #expect(throws: Time.Conversion.Error.overflow) {
            try Time.Conversion.count(count, to: Time.Second.self)
        }
        let exact = try Time.Conversion.count(Time.Minute.count(Cardinal(UInt.max / 60)), to: Time.Second.self)
        #expect(exact.underlying.rawValue == UInt.max / 60 * 60)
        #expect(try Time.Conversion.count(Time.Second.count(maximum), to: Time.Second.self).underlying == maximum)
    }

    @Test(arguments: [Polarity.positive, .negative])
    func `offset conversion preserves both signs and reports storage overflow`(polarity: Polarity) throws {
        let maximum = Difference(polarity: polarity, magnitude: Difference.Magnitude(Cardinal(UInt.max)))
        #expect(throws: Time.Conversion.Error.overflow) {
            try Time.Conversion.offset(Time.Minute.offset(maximum), to: Time.Second.self)
        }
        let identity = try Time.Conversion.offset(Time.Second.offset(maximum), to: Time.Second.self)
        #expect(identity.underlying == maximum)
    }

    @Test func `exact quantities exceed fixed storage while discrete conversion reports overflow`() throws {
        let converted = try Large(3).converted(to: Time.Second.self)
        #expect(converted.value == Rational(Int128.max) * Rational(3))
        #expect(try converted.converted(to: Large.self).value == 3)
        #expect(throws: Time.Conversion.Error.overflow) {
            try Time.Conversion.count(Large.count(Cardinal(3 as UInt)), to: Time.Second.self)
        }
        #expect(throws: Time.Conversion.Error.overflow) {
            try Time.Conversion.offset(Large.offset(Difference(-3)), to: Time.Second.self)
        }
    }

    @Test func `instant conversion wraps temporal failures and preserves precision failures`() {
        let origin = Instant(secondsSinceUnixEpoch: 0)
        #expect(throws: Instant.Error.conversion(.zeroFactor)) { try origin.advanced(by: Zero(1)) }
        #expect(throws: Instant.Error.conversion(.negativeFactor)) { try origin.advanced(by: Negative(1)) }
        #expect(throws: Instant.Error.precision) { try origin.advanced(by: Time.Picosecond(1)) }
        #expect(throws: Instant.Error.overflow) { try origin.advanced(by: Large(1)) }
    }

    @Test func `typed conversion errors retain checked conformances across unit pairs`() throws {
        func requireCheckedError<E: Swift.Error & Hashable & Sendable>(_ error: E) {}
        do throws(Time.Conversion.Error) {
            _ = try Time.Conversion.offset(Time.Second.offset(Difference(1)), to: Time.Minute.self)
            Issue.record("An integral second cannot be an integral minute")
        } catch {
            requireCheckedError(error)
            #expect(error == .inexact)
        }
        do throws(Time.Conversion.Error) {
            _ = try Time.Conversion.count(Time.Hour.count(Cardinal(UInt.max)), to: Time.Second.self)
            Issue.record("The converted count exceeds its fixed storage")
        } catch {
            requireCheckedError(error)
            #expect(error == .overflow)
        }
    }
}
