public import Ratio

extension Time.Hour: Time.Unit {
    public static var seconds: Ratio<Time.Hour, Time.Second> {
        let step: Ratio<Time.Hour, Time.Minute> =
            Time.Conversion.scale(numerator: 60, denominator: 1)
        do { return try step.composed(with: Time.Minute.seconds) }
        catch { preconditionFailure("The temporal unit scale is representable") }
    }
}
