extension Time {
    /// A chosen reference value. Its representation supplies its interpretation.
    /// Calendar reference dates can be used without introducing a calendar dependency here.
    public struct Epoch<Reference> {
        public let referenceDate: Reference

        public init(referenceDate: Reference) {
            self.referenceDate = referenceDate
        }
    }
}

extension Time.Epoch: Sendable where Reference: Sendable {}
extension Time.Epoch: Equatable where Reference: Equatable {}
extension Time.Epoch: Hashable where Reference: Hashable {}

extension Time.Epoch where Reference == Instant {
    /// Translation and displacement reuse Instant's arithmetic and precision contract.
    public func instant(after duration: Duration) -> Instant {
        referenceDate + duration
    }

    public func duration(to instant: Instant) -> Duration {
        instant - referenceDate
    }
}


extension Time.Epoch where Reference == Instant {
    public func instant<Unit: Time.Unit>(
        after quantity: Time.Quantity<Unit>
    ) throws(Instant.Error) -> Instant {
        try referenceDate.advanced(by: quantity)
    }

    public func instant(exactlyAfter duration: Duration) throws(Instant.Error) -> Instant {
        try referenceDate.advanced(exactly: duration)
    }

    public func displacement(to instant: Instant) -> Time.Nanosecond.Quantity {
        referenceDate.displacement(to: instant)
    }
}
