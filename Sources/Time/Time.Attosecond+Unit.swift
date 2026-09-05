public import Ratio

extension Time.Attosecond: Time.Unit {
    public static var seconds: Ratio<Time.Attosecond, Time.Second> {
        let step: Ratio<Time.Attosecond, Time.Femtosecond> =
            Time.Conversion.scale(numerator: 1, denominator: 1000)
        do { return try step.composed(with: Time.Femtosecond.seconds) }
        catch { preconditionFailure("The temporal unit scale is representable") }
    }
}
