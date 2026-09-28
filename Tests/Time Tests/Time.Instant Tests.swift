import Testing
import Time

@Test func `Unix epoch uses the instant`() {
    let unix = Time.Instant(secondsSinceUnixEpoch: 0)
    let epoch = Time.Epoch(referenceDate: unix)
    let later: Time.Instant = epoch.instant(after: .seconds(1))
    #expect(later.secondsSinceUnixEpoch == 1)
}
