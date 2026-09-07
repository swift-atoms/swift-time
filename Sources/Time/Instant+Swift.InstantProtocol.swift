extension Instant: Swift.InstantProtocol {
    public typealias Duration = Swift.Duration
    public func advanced(by duration: Duration) -> Self { self + duration }
    public func duration(to other: Self) -> Duration { other - self }
}
