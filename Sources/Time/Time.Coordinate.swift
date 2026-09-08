extension Time {
    /// A temporal point relative to a reference chosen by its domain.
    ///
    /// This type assigns no epoch, clock, unit quantization, or platform source.
    /// Its duration is the displacement from the reference, not the point itself.
    /// Use a domain tag when points from different timelines must remain distinct.
    public struct Coordinate: Sendable, Hashable {
        public typealias Duration = Swift.Duration

        public let offset: Duration

        @inlinable
        public init(offset: Duration) { self.offset = offset }

        /// The coordinate origin, not an observation of the current time.
        @inlinable
        public static var reference: Self { Self(offset: .zero) }
    }
}

extension Time.Coordinate: Swift.Comparable {
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool { lhs.offset < rhs.offset }
}

extension Time.Coordinate: Swift.InstantProtocol {
    /// The result must fit `Swift.Duration`; overflow traps, as in native arithmetic.
    @inlinable
    public func advanced(by duration: Duration) -> Self {
        Self(offset: offset + duration)
    }

    /// The difference must fit `Swift.Duration`, even if both coordinates do.
    @inlinable
    public func duration(to other: Self) -> Duration { other.offset - offset }
}

extension Time.Coordinate {
    public enum Error: Swift.Error, Equatable {
        case overflow
    }

    /// Checked translation for callers that must report unrepresentable coordinates.
    @inlinable
    public func advanced(exactly duration: Duration) throws(Error) -> Self {
        let result = offset.attoseconds.addingReportingOverflow(duration.attoseconds)
        guard !result.overflow else { throw .overflow }
        return Self(offset: Duration(attoseconds: result.partialValue))
    }

    @inlinable
    public func retreated(exactlyBy duration: Duration) throws(Error) -> Self {
        let result = offset.attoseconds.subtractingReportingOverflow(duration.attoseconds)
        guard !result.overflow else { throw .overflow }
        return Self(offset: Duration(attoseconds: result.partialValue))
    }

    @inlinable
    public func duration(exactlyTo other: Self) throws(Error) -> Duration {
        let result = other.offset.attoseconds.subtractingReportingOverflow(offset.attoseconds)
        guard !result.overflow else { throw .overflow }
        return Duration(attoseconds: result.partialValue)
    }
}

extension Time.Coordinate {
    @inlinable
    public static func + (lhs: Self, rhs: Duration) -> Self { lhs.advanced(by: rhs) }

    @inlinable
    public static func + (lhs: Duration, rhs: Self) -> Self { rhs.advanced(by: lhs) }

    @inlinable
    public static func += (lhs: inout Self, rhs: Duration) { lhs = lhs + rhs }

    /// Subtract directly: negating the minimum duration would overflow unnecessarily.
    @inlinable
    public static func - (lhs: Self, rhs: Duration) -> Self {
        Self(offset: lhs.offset - rhs)
    }

    @inlinable
    public static func -= (lhs: inout Self, rhs: Duration) { lhs = lhs - rhs }

    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Duration { rhs.duration(to: lhs) }
}
