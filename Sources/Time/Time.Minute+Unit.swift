public import Ratio

extension Time.Minute: Time.Unit {
    public static var seconds: Ratio<Time.Minute, Time.Second> {
        Time.Conversion.scale(numerator: 60, denominator: 1)
    }
}
