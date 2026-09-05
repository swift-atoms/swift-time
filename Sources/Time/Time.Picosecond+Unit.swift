public import Ratio

extension Time.Picosecond: Time.Unit {
    public static var seconds: Ratio<Time.Picosecond, Time.Second> {
        let step: Ratio<Time.Picosecond, Time.Nanosecond> =
            Time.Conversion.scale(numerator: 1, denominator: 1000)
        do { return try step.composed(with: Time.Nanosecond.seconds) }
        catch { preconditionFailure("The temporal unit scale is representable") }
    }
}
