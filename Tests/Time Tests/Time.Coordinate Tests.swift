import Foundation
import Testing
import Time

@Suite struct `Unix instant projections preserve their bounded representation` {
    @Test(arguments: [Int64.min, -2, -1, 0, 1, Int64.max], [Int32(0), 1, 500_000_000, 999_999_999])
    func `unix projection retains normalized seconds fractions and wire format`(
        seconds: Int64,
        fraction: Int32
    ) throws {
        let instant = try Instant(secondsSinceUnixEpoch: seconds, nanosecondFraction: fraction)
        let coordinate = Time.Coordinate(offset: .seconds(seconds) + .nanoseconds(fraction))
        let epoch = Instant(secondsSinceUnixEpoch: 0)

        #expect(instant.secondsSinceUnixEpoch == seconds)
        #expect(instant.position.rawValue == seconds)
        #expect(instant.nanosecondFraction == fraction)
        #expect(epoch.duration(to: instant) == coordinate.offset)
        #expect(try epoch.advanced(exactly: coordinate.offset) == instant)
        let bytes = try JSONEncoder().encode(instant)
        let fields = try #require(JSONSerialization.jsonObject(with: bytes) as? [String: Any])
        #expect(Set(fields.keys) == ["secondsSinceUnixEpoch", "nanosecondFraction"])
        #expect(try JSONDecoder().decode(Instant.self, from: bytes) == instant)
    }

    @Test
    func `unix validation rejects coordinate overflow and subnanosecond precision`() {
        let first = Instant(secondsSinceUnixEpoch: .min)
        let last = Instant(secondsSinceUnixEpoch: .max)
        let largePositive = Swift.Duration(attoseconds: Int128.max / 1_000_000_000 * 1_000_000_000)
        let largeNegative = Swift.Duration(attoseconds: Int128.min / 1_000_000_000 * 1_000_000_000)
        #expect(throws: Instant.Error.overflow) { try last.advanced(exactly: largePositive) }
        #expect(throws: Instant.Error.overflow) { try first.advanced(exactly: largeNegative) }
        #expect(throws: Instant.Error.overflow) { try last.advanced(by: Time.Nanosecond(Int128.max)) }
        #expect(throws: Instant.Error.overflow) { try first.advanced(by: Time.Nanosecond(Int128.min)) }
        #expect(throws: Instant.Error.precision) { try first.advanced(exactly: .init(attoseconds: -1)) }
    }
}
