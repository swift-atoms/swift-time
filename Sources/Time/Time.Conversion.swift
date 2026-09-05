/// Mixed-radix arithmetic for a uniform, 24-hour clock coordinate.
/// A clock-coordinate day here is not a claim about elapsed civil-day length.
extension Time {
    public enum Conversion {}
}

extension Time.Conversion {
    public static let secondsPerMinute = 60
    public static let minutesPerHour = 60
    public static let hoursPerDay = 24
    public static let secondsPerHour = secondsPerMinute * minutesPerHour
    public static let secondsPerDay = secondsPerHour * hoursPerDay

    public static func seconds(hour: Time.Hour, minute: Time.Minute, second: Time.Second) -> Int {
        hour.value * secondsPerHour + minute.value * secondsPerMinute + second.value
    }

    /// Euclidean division preserves the day carry for negative coordinates.
    public static func components(fromSeconds seconds: Int) -> (
        days: Int, hour: Time.Hour, minute: Time.Minute, second: Time.Second
    ) {
        let quotient = seconds / secondsPerDay
        let remainder = seconds % secondsPerDay
        let days = remainder < 0 ? quotient - 1 : quotient
        let clock = remainder < 0 ? remainder + secondsPerDay : remainder
        return (
            days,
            Time.Hour(unchecked: clock / secondsPerHour),
            Time.Minute(unchecked: (clock % secondsPerHour) / secondsPerMinute),
            Time.Second(unchecked: clock % secondsPerMinute)
        )
    }
}
