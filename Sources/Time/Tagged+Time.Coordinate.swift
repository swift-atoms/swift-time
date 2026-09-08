public import Coordinate
public import Tagged

extension Tagged where Tag == Time, Underlying == Coordinate::Coordinate<1, Swift.Duration> {
    /// A temporal coordinate relative to a reference chosen by its domain.
    public init(offset: Swift.Duration) { self.init(_unchecked: Underlying(rawValue: offset)) }
    public var offset: Swift.Duration { underlying.rawValue }
    public static var reference: Self { Self(offset: .zero) }
}
