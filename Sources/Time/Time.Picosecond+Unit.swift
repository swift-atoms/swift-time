public import Ratio

extension Time.Picosecond: Time.Unit {
    public static var seconds: Ratio<Time.Picosecond, Time.Second> {
        do {
            return try Ratio<Time.Picosecond, Time.Nanosecond>.default
                .composed(with: Time.Nanosecond.seconds)
        }
        catch { preconditionFailure("The temporal unit scale is representable") }
    }
}

extension Ratio<Time.Picosecond, Time.Nanosecond> {
    static let `default`: Self = Time.Conversion.scale(numerator: 1, denominator: 1000)
}
