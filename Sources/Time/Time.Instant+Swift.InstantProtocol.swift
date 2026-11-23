extension Time.Instant: Swift.InstantProtocol {
    public typealias Duration = Swift.Duration
    public func advanced(by duration: Swift.Duration) -> Self { self + duration }
    public func duration(to other: Self) -> Swift.Duration { other - self }
}
