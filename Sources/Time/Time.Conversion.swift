import Ratio
internal import Division

/// Mixed-radix arithmetic for a uniform, 24-hour clock coordinate.
/// A clock-coordinate day here is not a claim about elapsed civil-day length.
extension Time {
    public enum Conversion {}
}

extension Time.Conversion {
    public static var secondsPerMinute: Int { constant(Time.Minute.self) }
    public static var minutesPerHour: Int { secondsPerHour / secondsPerMinute }
    public static var hoursPerDay: Int { secondsPerDay / secondsPerHour }
    public static var secondsPerHour: Int { constant(Time.Hour.self) }
    public static var secondsPerDay: Int { constant(Time.Day.self) }

    public static func seconds(hour: Time.Day.Hour, minute: Time.Hour.Minute, second: Time.Minute.Second) -> Int {
        hour.value * secondsPerHour + minute.value * secondsPerMinute + second.value
    }

    /// Euclidean division preserves the day carry for negative coordinates.
    public static func components(fromSeconds seconds: Int) -> (
        days: Int, hour: Time.Day.Hour, minute: Time.Hour.Minute, second: Time.Minute.Second
    ) {
        let split: (quotient: Int, remainder: Int)
        do { split = try Division.euclidean(seconds, by: secondsPerDay) }
        catch { preconditionFailure("Uniform-day division has a positive, representable divisor") }
        let days = split.quotient
        let clock = split.remainder
        return (
            days,
            Time.Day.Hour(unchecked: clock / secondsPerHour),
            Time.Hour.Minute(unchecked: (clock % secondsPerHour) / secondsPerMinute),
            Time.Minute.Second(unchecked: clock % secondsPerMinute)
        )
    }
}


extension Time.Conversion {
    private static func constant<Unit: Time.Unit>(_ unit: Unit.Type) -> Int {
        do { return Int(try unit.seconds.applying(to: 1 as Int128)) }
        catch { preconditionFailure("Integral clock-unit scales are representable") }
    }
}
