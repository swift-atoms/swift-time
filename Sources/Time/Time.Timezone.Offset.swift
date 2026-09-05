extension Time.Timezone {

    public struct Offset {

        public let seconds: Int

        public init(seconds: Int) {
            self.seconds = seconds
        }

    }
}

extension Time.Timezone.Offset {

    public static let utc = Self(seconds: 0)

    public var hours: Int {
        seconds / Time.Conversion.secondsPerHour
    }

    public var minutes: Int {
        abs(seconds % Time.Conversion.secondsPerHour)
            / Time.Conversion.secondsPerMinute
    }

    public var isUTC: Bool {
        seconds == 0
    }
}

extension Time.Timezone.Offset: CustomStringConvertible {

    public var description: String {
        if seconds == 0 {
            return "+00:00"
        }

        let sign = seconds >= 0 ? "+" : "-"
        let absHours = abs(hours)
        let absMinutes = minutes

        let hourStr = absHours < 10 ? "0\(absHours)" : "\(absHours)"
        let minStr = absMinutes < 10 ? "0\(absMinutes)" : "\(absMinutes)"

        return "\(sign)\(hourStr):\(minStr)"
    }
}

extension Time.Timezone.Offset: Comparable {

    public static func < (lhs: Time.Timezone.Offset, rhs: Time.Timezone.Offset) -> Bool {
        lhs.seconds < rhs.seconds
    }
}

#if !hasFeature(Embedded)
    extension Time.Timezone.Offset: Codable {}
#endif

extension Time.Timezone.Offset: Sendable {}
extension Time.Timezone.Offset: Equatable {}
extension Time.Timezone.Offset: Hashable {}

extension Time.Timezone.Offset {
    public init(hours: Int, minutes: Int = 0) {
        let sign = hours < 0 ? -1 : 1
        self.seconds =
            hours * Time.Conversion.secondsPerHour + sign * minutes
            * Time.Conversion.secondsPerMinute
    }
}
