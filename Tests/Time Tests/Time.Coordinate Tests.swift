import Foundation
import Tagged
import Testing
import Time

private enum Experiment {}
private struct NoncopyableTimeline: ~Copyable {}

@Suite
struct `Origin neutral temporal coordinates` {
    @Test(arguments: [Int128.min, Int128.min + 1, -1_000_000_001, -1, 0, 1, Int128.max])
    func `reference translation preserves the entire signed attosecond range`(
        attoseconds: Int128
    ) throws {
        let duration = Swift.Duration(attoseconds: attoseconds)
        let origin = Time.Coordinate.reference
        let point = origin + duration

        #expect(point.offset == duration)
        #expect(point - origin == duration)
        #expect(point - duration == origin)
        #expect(duration + origin == point)
        #expect(try origin.advanced(exactly: duration) == point)
        #expect(try origin.duration(exactlyTo: point) == duration)
        #expect(try point.retreated(exactlyBy: duration) == origin)
        #expect((point < origin) == (duration < .zero))
    }

    @Test
    func `subnanosecond translation is reversible across the reference`() {
        let attosecond = Swift.Duration(attoseconds: 1)
        var point = Time.Coordinate.reference
        point -= attosecond
        #expect(point.offset.attoseconds == -1)
        point += attosecond
        #expect(point == .reference)
    }

    @Test
    func `checked arithmetic reports overflow without wrapping or trapping`() {
        let minimum = Time.Coordinate(offset: .init(attoseconds: .min))
        let maximum = Time.Coordinate(offset: .init(attoseconds: .max))
        let attosecond = Swift.Duration(attoseconds: 1)

        #expect(throws: Time.Coordinate.Error.overflow) {
            try maximum.advanced(exactly: attosecond)
        }
        #expect(throws: Time.Coordinate.Error.overflow) {
            try minimum.advanced(exactly: .init(attoseconds: -1))
        }
        #expect(throws: Time.Coordinate.Error.overflow) {
            try minimum.retreated(exactlyBy: attosecond)
        }
        #expect(throws: Time.Coordinate.Error.overflow) {
            try maximum.retreated(exactlyBy: .init(attoseconds: -1))
        }
        #expect(throws: Time.Coordinate.Error.overflow) {
            try minimum.duration(exactlyTo: maximum)
        }
        #expect(throws: Time.Coordinate.Error.overflow) {
            try maximum.duration(exactlyTo: minimum)
        }
    }

    @Test
    func `tagging a coordinate requires no clock dependency`() {
        let duration = Swift.Duration(attoseconds: .min)
        let point = Tagged<Experiment, Time.Coordinate>(offset: duration)
        let copy: Tagged<Experiment, Time.Coordinate> = point
        #expect(point.underlying == Time.Coordinate(offset: duration))
        #expect(copy - duration == .reference)

        var noncopyable = Tagged<NoncopyableTimeline, Time.Coordinate>(offset: duration)
        noncopyable -= duration
        #expect(noncopyable == .reference)
    }

    @Test
    func `coordinates and tagged coordinates satisfy the same instant contract`() {
        func translate<I: Swift.InstantProtocol>(_ point: I, by duration: I.Duration) -> I {
            point.advanced(by: duration)
        }
        let duration = Swift.Duration(attoseconds: 17)
        let point = translate(Time.Coordinate.reference, by: duration)
        let tagged = translate(Tagged<Experiment, Time.Coordinate>.reference, by: duration)
        #expect(tagged.underlying == point)
        #expect(Set([point, .reference, point]).count == 2)
        #expect(Set([tagged, .reference, tagged]).count == 2)
    }

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
