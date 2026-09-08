import Coordinate
import Tagged
import Testing
import Time

@Test(arguments: [Int128.min, -1, 0, 1, Int128.max])
func `Temporal instant is exactly its coordinate`(attoseconds: Int128) {
    let coordinate = Time.Coordinate(offset: .init(attoseconds: attoseconds))
    let instant: Time.Instant = coordinate
    let sameCoordinate: Time.Coordinate = instant
    let sameTagged: Tagged<Time, Coordinate::Coordinate<1, Swift.Duration>> = instant
    #expect(sameCoordinate == coordinate)
    #expect(sameTagged == coordinate)
    #expect(instant.offset.attoseconds == attoseconds)
}
@Test func `Unix epoch still uses the owned unix instant`() {
    let unix = Time::Instant(secondsSinceUnixEpoch: 0)
    let epoch = Time.Epoch(referenceDate: unix)
    let later: Time::Instant = epoch.instant(after: .seconds(1))
    #expect(later.secondsSinceUnixEpoch == 1)
}
