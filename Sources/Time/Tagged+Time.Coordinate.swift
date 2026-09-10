public import Coordinate
public import Tagged

extension Tagged where Tag == Time, Underlying == Coordinate::Coordinate<1, Swift.Duration> {

    public init(offset: Swift.Duration) { self.init(_unchecked: Underlying(rawValue: offset)) }
    public var offset: Swift.Duration { underlying.rawValue }
    public static var reference: Self { Self(offset: .zero) }
}
