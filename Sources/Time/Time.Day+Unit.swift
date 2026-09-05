public import Ratio

extension Time.Day: Time.Unit {
    public static var seconds: Ratio<Time.Day, Time.Second> {
        let step: Ratio<Time.Day, Time.Hour> =
            Time.Conversion.scale(numerator: 24, denominator: 1)
        do { return try step.composed(with: Time.Hour.seconds) }
        catch { preconditionFailure("The temporal unit scale is representable") }
    }
}
