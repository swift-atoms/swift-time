public import Ratio

extension Time.Femtosecond: Time.Unit {
    public static var seconds: Ratio<Time.Femtosecond, Time.Second> {
        let step: Ratio<Time.Femtosecond, Time.Picosecond> =
            Time.Conversion.scale(numerator: 1, denominator: 1000)
        do { return try step.composed(with: Time.Picosecond.seconds) }
        catch { preconditionFailure("The temporal unit scale is representable") }
    }
}
