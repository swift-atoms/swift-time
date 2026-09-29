import Foundation
import Testing
import Time
import Time_Foundation_Integration

@Suite
struct `Time.Instant converts to and from Foundation.Date` {

    @Test
    func `the Unix epoch maps to the reference date`() throws {
        let instant = try Time.Instant(Foundation.Date(timeIntervalSince1970: 0))
        #expect(instant.secondsSinceUnixEpoch == 0)
        #expect(instant.nanosecondFraction == 0)
        #expect(Foundation.Date(Time.Instant(secondsSinceUnixEpoch: 0)) == Foundation.Date(timeIntervalSince1970: 0))
    }

    @Test
    func `a positive fractional date keeps its nanoseconds`() throws {
        let instant = try Time.Instant(Foundation.Date(timeIntervalSince1970: 1_700_000_000.25))
        #expect(instant.secondsSinceUnixEpoch == 1_700_000_000)
        #expect(instant.nanosecondFraction == 250_000_000)
    }

    @Test
    func `a negative fractional date floors its seconds`() throws {
        let instant = try Time.Instant(Foundation.Date(timeIntervalSince1970: -1.5))
        #expect(instant.secondsSinceUnixEpoch == -2)
        #expect(instant.nanosecondFraction == 500_000_000)
    }

    @Test
    func `an instant round-trips through a date`() throws {
        let instant = try Time.Instant(secondsSinceUnixEpoch: 1_234_567_890, nanosecondFraction: 125_000_000)
        #expect(try Time.Instant(Foundation.Date(instant)) == instant)
    }

    @Test
    func `a date round-trips through an instant within a microsecond`() throws {
        let date = Foundation.Date(timeIntervalSince1970: 987_654_321.123456)
        let back = Foundation.Date(try Time.Instant(date))
        #expect(abs(back.timeIntervalSince(date)) < 0.000_001)
    }

    @Test(arguments: [Double.infinity, -Double.infinity, Double.nan, 1e30])
    func `an unrepresentable date throws overflow`(_ interval: Double) {
        #expect(throws: Time.Instant.Error.overflow) {
            try Time.Instant(Foundation.Date(timeIntervalSince1970: interval))
        }
    }
}
