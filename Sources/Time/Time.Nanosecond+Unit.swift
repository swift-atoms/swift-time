public import Ratio

extension Time.Nanosecond: Time.Unit {
    public static var seconds: Ratio<Time.Nanosecond, Time.Second> {
        let step: Ratio<Time.Nanosecond, Time.Microsecond> =
            Time.Conversion.scale(numerator: 1, denominator: 1000)
        do { return try step.composed(with: Time.Microsecond.seconds) }
        catch { preconditionFailure("The temporal unit scale is representable") }
    }
}
