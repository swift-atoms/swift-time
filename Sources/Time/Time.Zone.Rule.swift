internal import Magnitude
internal import Polarity
internal import Cardinal
internal import Tagged
public import Translation

extension Translation where Displacement == Time.Second.Offset {

    public struct Rule {
        private let resolve: @Sendable (Time.Instant) -> Time.Zone

        public init(_ offset: @escaping @Sendable (Time.Instant) -> Time.Zone) {
            self.resolve = offset
        }
    }
}

extension Time.Zone.Rule {
    public func offset(at instant: Time.Instant) -> Time.Zone { resolve(instant) }

    public func instant(
        local: Time.Instant,
        ambiguous: Policy,
        skipped: Policy
    ) throws(Time.Instant.Error) -> Time.Instant {
        let day = Swift.Duration.seconds(Time.Conversion.secondsPerDay)
        let before = offset(at: try local.advanced(exactly: .zero - day))
        let after = offset(at: try local.advanced(exactly: day))
        let first = try local.advanced(exactly: .zero - Self.duration(of: before))
        let second = try local.advanced(exactly: .zero - Self.duration(of: after))
        let firstValid = offset(at: first) == before
        let secondValid = offset(at: second) == after
        let candidates = switch (firstValid, secondValid) {
        case (true, false): (earlier: first, later: first)
        case (false, true): (earlier: second, later: second)
        default: (earlier: Swift.min(first, second), later: Swift.max(first, second))
        }
        return switch firstValid || secondValid ? ambiguous : skipped {
        case .earlier: candidates.earlier
        case .later: candidates.later
        }
    }

    private static func duration(of zone: Time.Zone) -> Swift.Duration {
        let offset = zone.offset.underlying
        let magnitude = Int128(offset.magnitude.value.rawValue)
        return .seconds(offset.polarity == .negative ? -magnitude : magnitude)
    }
}

extension Time.Zone.Rule: Swift.Sendable {}
