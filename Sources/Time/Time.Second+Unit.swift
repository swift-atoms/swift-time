public import Ratio

extension Time.Second: Time.Unit {
    public static var seconds: Ratio<Time.Second, Time.Second> {
        Time.Conversion.scale(numerator: 1, denominator: 1)
    }
}
