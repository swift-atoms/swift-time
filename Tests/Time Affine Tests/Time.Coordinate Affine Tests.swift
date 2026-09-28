#if Affine
import Testing
import Time

@Suite struct `Temporal affine operations preserve exact duration semantics` {
    @Test(arguments: [Int128.min, Int128.min + 1, -1_000_000_001, -1, 0, 1, Int128.max])
    func `Translation and difference preserve the native range`(attoseconds: Int128) throws {
        let relation = Time.Coordinate.temporal
        let duration = Swift.Duration(attoseconds: attoseconds)
        let origin = Time.Coordinate.reference
        let point: Time.Coordinate = try relation.translated(origin, by: duration)
        #expect(point.offset == duration)
        #expect(try relation.displacement(from: origin, to: point) == duration)
        #expect(try relation.displacement(from: point, to: point) == .zero)
        #expect(try relation.translated(point, by: .zero) == point)
        #expect((point < origin) == (duration < .zero))
        if attoseconds != .min {
            #expect(try relation.translated(point, by: .init(attoseconds: -attoseconds)) == origin)
        }
    }

    @Test func `Composition crosses the reference without quantization`() throws {
        let relation = Time.Coordinate.temporal
        let origin = Time.Coordinate.reference
        let before = try relation.translated(origin, by: .init(attoseconds: -1))
        let after = try relation.translated(before, by: .init(attoseconds: 2))
        #expect(after.offset.attoseconds == 1)
        #expect(try relation.displacement(from: before, to: after).attoseconds == 2)
        #expect(try relation.translated(origin, by: .init(attoseconds: 1)) == after)
    }

    @Test func `Minimum coordinate can translate across the full range in representable steps`() throws {
        let relation = Time.Coordinate.temporal
        let minimum = Time.Coordinate(offset: .init(attoseconds: .min))
        let before = try relation.translated(minimum, by: .init(attoseconds: .max))
        #expect(before.offset.attoseconds == -1)
        #expect(try relation.translated(before, by: .init(attoseconds: 1)) == .reference)
    }

    @Test func `Arithmetic overflow is reported explicitly`() {
        let relation = Time.Coordinate.temporal
        let minimum = Time.Coordinate(offset: .init(attoseconds: .min))
        let maximum = Time.Coordinate(offset: .init(attoseconds: .max))
        #expect(throws: Time.Instant.Error.overflow) {
            try relation.translated(maximum, by: .init(attoseconds: 1))
        }
        #expect(throws: Time.Instant.Error.overflow) {
            try relation.translated(minimum, by: .init(attoseconds: -1))
        }
        #expect(throws: Time.Instant.Error.overflow) {
            try relation.displacement(from: minimum, to: maximum)
        }
        #expect(throws: Time.Instant.Error.overflow) {
            try relation.displacement(from: maximum, to: minimum)
        }
        #expect(throws: Time.Instant.Error.overflow) {
            try relation.displacement(from: minimum, to: .reference)
        }
    }
}
#endif
