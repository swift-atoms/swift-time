public import Coordinate
public import Tagged

extension Time {
    /// A temporal coordinate, without imposing a Unix epoch or clock source.
    /// The general coordinate representation is dimension-independent; time uses
    /// its one-dimensional Swift.Duration specialization.
    public typealias Coordinate = Tagged<Time, Coordinate::Coordinate<1, Swift.Duration>>
}
