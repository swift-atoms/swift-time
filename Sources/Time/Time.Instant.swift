extension Time {
    /// An origin-neutral temporal instant, represented by a temporal coordinate.
    ///
    /// This is an alias, not a wrapper or a Swift.InstantProtocol conformance.
    /// The provider establishes the reference; no Unix epoch is implied.
    public typealias Instant = Coordinate
}
