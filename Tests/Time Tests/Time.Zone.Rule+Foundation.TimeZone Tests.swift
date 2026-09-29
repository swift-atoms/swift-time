import Foundation
import Testing
import Time
import Time_Foundation_Integration

@Suite
struct `Time.Zone.Rule bridges a Foundation.TimeZone` {

    @Test(arguments: [-18_000, 0, 3_600, 20_700])
    func `a fixed Foundation zone yields its offset`(_ seconds: Int) throws {
        let zone = try #require(TimeZone(secondsFromGMT: seconds))
        let rule = Time.Zone.Rule(zone)
        #expect(rule.offset(at: Time.Instant(secondsSinceUnixEpoch: 1_700_000_000)) == .seconds(seconds))
    }

    @Test
    func `a local time in a fixed Foundation zone resolves through its offset`() throws {
        let zone = try #require(TimeZone(secondsFromGMT: 3_600))
        let local = Time.Instant(secondsSinceUnixEpoch: 1_700_003_600)
        #expect(
            try Time.Zone.Rule(zone).instant(local: local, ambiguous: .earlier, skipped: .later)
                == Time.Instant(secondsSinceUnixEpoch: 1_700_000_000)
        )
    }
}
