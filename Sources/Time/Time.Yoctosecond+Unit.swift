public import Ratio

extension Time.Yoctosecond: Time.Unit {
    public static var seconds: Ratio<Time.Yoctosecond, Time.Second> {
        let step: Ratio<Time.Yoctosecond, Time.Zeptosecond> =
            Time.Conversion.scale(numerator: 1, denominator: 1000)
        do { return try step.composed(with: Time.Zeptosecond.seconds) }
        catch { preconditionFailure("The temporal unit scale is representable") }
    }
}
