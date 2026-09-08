import Tagged
import Difference
import Testing
import Time

@Suite struct `Temporal components preserve their distinct roles` {
    @Test func `every fractional component is preserved`() throws {
        for value in [0, 1, 123, 999] {
            #expect(try Time.Second.Millisecond(value).value == value)
            #expect(try Time.Millisecond.Microsecond(value).value == value)
            #expect(try Time.Microsecond.Nanosecond(value).value == value)
            #expect(try Time.Nanosecond.Picosecond(value).value == value)
            #expect(try Time.Picosecond.Femtosecond(value).value == value)
            #expect(try Time.Femtosecond.Attosecond(value).value == value)
            #expect(try Time.Attosecond.Zeptosecond(value).value == value)
            #expect(try Time.Zeptosecond.Yoctosecond(value).value == value)
        }
        for value in [-1, 1000] {
            #expect(throws: Time.Second.Millisecond.Error.self) { try Time.Second.Millisecond(value) }
            #expect(throws: Time.Millisecond.Microsecond.Error.self) { try Time.Millisecond.Microsecond(value) }
            #expect(throws: Time.Microsecond.Nanosecond.Error.self) { try Time.Microsecond.Nanosecond(value) }
            #expect(throws: Time.Nanosecond.Picosecond.Error.self) { try Time.Nanosecond.Picosecond(value) }
            #expect(throws: Time.Picosecond.Femtosecond.Error.self) { try Time.Picosecond.Femtosecond(value) }
            #expect(throws: Time.Femtosecond.Attosecond.Error.self) { try Time.Femtosecond.Attosecond(value) }
            #expect(throws: Time.Attosecond.Zeptosecond.Error.self) { try Time.Attosecond.Zeptosecond(value) }
            #expect(throws: Time.Zeptosecond.Yoctosecond.Error.self) { try Time.Zeptosecond.Yoctosecond(value) }
        }
        #expect(Time.Picosecond.Femtosecond.zero.value == 0)
        #expect(Time.Femtosecond.Attosecond.zero.value == 0)
        #expect(Time.Attosecond.Zeptosecond.zero.value == 0)
        #expect(Time.Zeptosecond.Yoctosecond.zero.value == 0)
    }

    @Test(arguments: [-172_801, -86_400, -1, 0, 1, 86_399, 86_400, 172_801])
    func `Dividing seconds yields whole days and a bounded remainder that reconstruct the input`(seconds: Int) {
        let components = Time.Conversion.components(fromSeconds: seconds)
        let clock = Time.Conversion.seconds(
            hour: components.hour, minute: components.minute, second: components.second
        )
        #expect(components.days * Time.Conversion.secondsPerDay + clock == seconds)
        #expect((0..<Time.Conversion.secondsPerDay).contains(clock))
    }

    @Test func `Instant translation preserves epoch displacements and fractional coordinates`() throws {
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

    @Test func `offsets have no calendar dependency`() throws {
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
