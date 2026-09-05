public import Ratio

extension Time.Millisecond: Time.Unit {
    public static var seconds: Ratio<Time.Millisecond, Time.Second> {
        Time.Conversion.scale(numerator: 1, denominator: 1000)
    }
}
