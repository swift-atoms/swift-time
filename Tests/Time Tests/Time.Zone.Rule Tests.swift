import Testing
import Time

private let transition: Int64 = 1_000_000

private func rule(from before: Int, to after: Int) -> Time.Zone.Rule {
    Time.Zone.Rule { instant in .seconds(instant.secondsSinceUnixEpoch < transition ? before : after) }
}

private func reading(_ seconds: Int64) -> Time.Instant {
    Time.Instant(secondsSinceUnixEpoch: transition + seconds)
}

@Suite
struct `Time.Zone.Rule resolves offsets and local times` {

    @Test
    func `the offset follows the rule on either side of a transition`() {
        let spring = rule(from: 3_600, to: 7_200)
        #expect(spring.offset(at: reading(-1)) == .seconds(3_600))
        #expect(spring.offset(at: reading(0)) == .seconds(7_200))
    }

    @Test(arguments: [Int64(-86_400), -3_601, 0, 7_200, 86_400])
    func `an unambiguous local time has one instant under every policy`(_ seconds: Int64) throws {
        let spring = rule(from: 3_600, to: 7_200)
        let local = reading(seconds)
        let expected = Time.Instant(
            secondsSinceUnixEpoch: local.secondsSinceUnixEpoch
                - Int64(seconds < 3_600 ? 3_600 : 7_200)
        )
        for ambiguous in [Time.Zone.Rule.Policy.earlier, .later] {
            for skipped in [Time.Zone.Rule.Policy.earlier, .later] {
                #expect(try spring.instant(local: local, ambiguous: ambiguous, skipped: skipped) == expected)
            }
        }
    }

    @Test
    func `a repeated local time resolves to its earlier or later occurrence`() throws {
        let autumn = rule(from: 7_200, to: 3_600)
        let local = reading(5_400)
        #expect(try autumn.instant(local: local, ambiguous: .earlier, skipped: .later) == reading(-1_800))
        #expect(try autumn.instant(local: local, ambiguous: .later, skipped: .earlier) == reading(1_800))
    }

    @Test
    func `a skipped local time shifts back or forward by the gap`() throws {
        let spring = rule(from: 3_600, to: 7_200)
        let local = reading(5_400)
        #expect(try spring.instant(local: local, ambiguous: .later, skipped: .earlier) == reading(-1_800))
        #expect(try spring.instant(local: local, ambiguous: .earlier, skipped: .later) == reading(1_800))
    }

    @Test
    func `the first skipped local time resolves later to the transition itself`() throws {
        let spring = rule(from: 3_600, to: 7_200)
        #expect(try spring.instant(local: reading(3_600), ambiguous: .earlier, skipped: .later) == reading(0))
    }

    @Test
    func `a local time beyond the representable range throws overflow`() {
        let spring = rule(from: 3_600, to: 7_200)
        #expect(throws: Time.Instant.Error.overflow) {
            try spring.instant(
                local: Time.Instant(secondsSinceUnixEpoch: .max),
                ambiguous: .earlier, skipped: .later
            )
        }
    }
}
