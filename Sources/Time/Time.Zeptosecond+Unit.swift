public import Ratio

extension Time.Zeptosecond: Time.Unit {
    public static var seconds: Ratio<Time.Zeptosecond, Time.Second> {
        let step: Ratio<Time.Zeptosecond, Time.Attosecond> =
            Time.Conversion.scale(numerator: 1, denominator: 1000)
        do { return try step.composed(with: Time.Attosecond.seconds) }
        catch { preconditionFailure("The temporal unit scale is representable") }
    }
}
