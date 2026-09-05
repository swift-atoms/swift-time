public import Ratio

extension Time.Microsecond: Time.Unit {
    public static var seconds: Ratio<Time.Microsecond, Time.Second> {
        let step: Ratio<Time.Microsecond, Time.Millisecond> =
            Time.Conversion.scale(numerator: 1, denominator: 1000)
        do { return try step.composed(with: Time.Millisecond.seconds) }
        catch { preconditionFailure("The temporal unit scale is representable") }
    }
}
