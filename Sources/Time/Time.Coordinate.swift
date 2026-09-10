public import Coordinate
public import Tagged

extension Time {

    public typealias Coordinate = Tagged<Time, Coordinate::Coordinate<1, Swift.Duration>>
}
