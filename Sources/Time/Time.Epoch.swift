extension Time {
    public struct Epoch<Reference> {
        public let referenceDate: Reference

        public init(referenceDate: Reference) {
            self.referenceDate = referenceDate
        }
    }
}

extension Time.Epoch: Swift.Sendable where Reference: Swift.Sendable {}

extension Time.Epoch: Swift.Equatable where Reference: Swift.Equatable {}

extension Time.Epoch: Swift.Hashable where Reference: Swift.Hashable {}

extension Time.Epoch where Reference == Time::Instant {
    public func instant(after duration: Duration) -> Time::Instant {
        referenceDate + duration
    }

    public func duration(to instant: Time::Instant) -> Duration {
        instant - referenceDate
    }
}

extension Time.Epoch where Reference == Time::Instant {
    public func instant<Unit: Time.Unit>(
        after quantity: Time.Quantity<Unit>
    ) throws(Time::Instant.Error) -> Time::Instant {
        try referenceDate.advanced(by: quantity)
    }

    public func instant(exactlyAfter duration: Duration) throws(Time::Instant.Error) -> Time::Instant {
        try referenceDate.advanced(exactly: duration)
    }

    public func displacement(to instant: Time::Instant) -> Time.Nanosecond {
        referenceDate.displacement(to: instant)
    }
}
