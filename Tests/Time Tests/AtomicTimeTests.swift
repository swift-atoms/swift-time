import Affine
import Tagged
import Difference
import Testing
import Time

@Suite struct AtomicTimeTests {
    @Test func everyFractionalComponentIsPreserved() throws {
        for value in [0, 1, 123, 999] {
            #expect(try Time.Millisecond(value).value == value)
            #expect(try Time.Microsecond(value).value == value)
            #expect(try Time.Nanosecond(value).value == value)
            #expect(try Time.Picosecond(value).value == value)
            #expect(try Time.Femtosecond(value).value == value)
            #expect(try Time.Attosecond(value).value == value)
            #expect(try Time.Zeptosecond(value).value == value)
            #expect(try Time.Yoctosecond(value).value == value)
        }
        for value in [-1, 1000] {
            #expect(throws: Time.Millisecond.Error.self) { try Time.Millisecond(value) }
            #expect(throws: Time.Microsecond.Error.self) { try Time.Microsecond(value) }
            #expect(throws: Time.Nanosecond.Error.self) { try Time.Nanosecond(value) }
            #expect(throws: Time.Picosecond.Error.self) { try Time.Picosecond(value) }
            #expect(throws: Time.Femtosecond.Error.self) { try Time.Femtosecond(value) }
            #expect(throws: Time.Attosecond.Error.self) { try Time.Attosecond(value) }
            #expect(throws: Time.Zeptosecond.Error.self) { try Time.Zeptosecond(value) }
            #expect(throws: Time.Yoctosecond.Error.self) { try Time.Yoctosecond(value) }
        }
        #expect(Time.Femtosecond.zero.value == 0)
        #expect(Time.Attosecond.zero.value == 0)
        #expect(Time.Zeptosecond.zero.value == 0)
        #expect(Time.Yoctosecond.zero.value == 0)
    }

    @Test(arguments: [-172_801, -86_400, -1, 0, 1, 86_399, 86_400, 172_801])
    func clockDivisionLaw(seconds: Int) {
        let components = Time.Conversion.components(fromSeconds: seconds)
        let clock = Time.Conversion.seconds(
            hour: components.hour, minute: components.minute, second: components.second
        )
        #expect(components.days * Time.Conversion.secondsPerDay + clock == seconds)
        #expect((0..<Time.Conversion.secondsPerDay).contains(clock))
    }

    @Test func instantTranslationAndEpochCoordinates() throws {
        let origin = try Instant(secondsSinceUnixEpoch: -1, nanosecondFraction: 999_999_999)
        let epoch = Time.Epoch(referenceDate: origin)
        let displacement = Duration.nanoseconds(2)
        let instant = epoch.instant(after: displacement)
        #expect(instant.secondsSinceUnixEpoch == 0)
        #expect(instant.nanosecondFraction == 1)
        #expect(epoch.duration(to: instant) == displacement)
        #expect(instant - displacement == origin)
        #expect(origin.advanced(by: displacement) == instant)
        #expect(origin + .zero == origin)
        #expect(try Time.totalNanoseconds(
            millisecond: .init(123), microsecond: .init(456), nanosecond: .init(789)
        ) == 123_456_789)
    }

    @Test func offsetsHaveNoCalendarDependency() throws {
        let offset = try Time.Zone.hours(-5, minutes: 30)
        #expect(try offset.offset.underlying.intValue() == -19_800)
        #expect(offset.description == "-05:30")
        #expect(offset.hours == -5)
        #expect(offset.minutes == 30)
        #expect(Time.Zone.utc.isUTC)
        #expect(Instant.milliseconds(from: nil) == -1)
        #expect(Instant.milliseconds(from: .seconds(1)) == 1000)
        #expect(Duration.nanoseconds(500_000_000).inSeconds == 0.5)
    }
}
