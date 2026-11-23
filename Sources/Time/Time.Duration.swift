public import Quantity

extension Time {
    /// A duration as a quantity: how long, stored in seconds as a scalar. It is the time of physics, beside the
    /// exact `Swift.Duration` of clocks, and converts from it.
    public enum Duration {}
}

extension Time.Duration: Quantity.Kind {
    public static var dimension: Quantity.Dimension { Quantity.Dimension(time: 1) }
}

extension Time.Duration {
    /// An amount of time, its scalar in seconds.
    public typealias Value<Scalar> = Tagged<Time.Duration, Scalar>

    /// An amount of time given in seconds.
    @inlinable
    public static func seconds<Scalar>(_ scalar: Scalar) -> Value<Scalar> {
        amount(scalar)
    }

    /// An exact duration as an amount of time, rounded to the nearest the scalar can hold.
    @inlinable
    public static func seconds<Scalar: BinaryFloatingPoint>(_ duration: Swift.Duration) -> Value<Scalar> {
        let parts = duration.components
        return amount(Scalar(parts.seconds) + Scalar(parts.attoseconds) / 1_000_000_000_000_000_000)
    }
}
