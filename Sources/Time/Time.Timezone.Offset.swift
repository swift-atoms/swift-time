import Tagged
import Polarity
import Magnitude
public import Affine
public import Difference
internal import Cardinal

extension Affine.Translation where Domain == Time.Second {
    public static var utc: Self { .identity }

    public static func seconds(_ seconds: Difference) -> Self {
        Self(offset: Time.Second.offset(seconds))
    }

    public static func seconds(_ seconds: Int) -> Self {
        .seconds(Difference(seconds))
    }

    /// Applies the hour sign to an unsigned minute component. With zero hours,
    /// a negative minute component can express a negative subhour offset.
    public static func hours(
        _ hours: Int, minutes: Int = 0
    ) throws(Difference.Error) -> Self {
        let value = Int128(hours) * Int128(Time.Conversion.secondsPerHour)
            + (hours < 0 ? -1 : 1) * Int128(minutes) * Int128(Time.Conversion.secondsPerMinute)
        guard let magnitude = UInt(exactly: value.magnitude) else { throw .overflow }
        return .seconds(Difference(
            polarity: value < 0 ? .negative : .positive,
            magnitude: Difference.Magnitude(Cardinal(magnitude))
        ))
    }

    public var isUTC: Bool { offset.underlying == .zero }

    public var hours: Int {
        let value = offset.underlying
        let magnitude = value.magnitude.value.rawValue / UInt(Time.Conversion.secondsPerHour)
        return value.polarity == .negative ? -Int(magnitude) : Int(magnitude)
    }

    public var minutes: Int {
        Int(offset.underlying.magnitude.value.rawValue % UInt(Time.Conversion.secondsPerHour)
            / UInt(Time.Conversion.secondsPerMinute))
    }

    /// Retains seconds when the fixed offset is not an integral number of minutes.
    public var description: String {
        let value = offset.underlying
        let magnitude = value.magnitude.value.rawValue
        let hours = magnitude / UInt(Time.Conversion.secondsPerHour)
        let minutes = magnitude % UInt(Time.Conversion.secondsPerHour)
            / UInt(Time.Conversion.secondsPerMinute)
        let seconds = magnitude % UInt(Time.Conversion.secondsPerMinute)
        func padded(_ value: UInt) -> String { value < 10 ? "0\(value)" : "\(value)" }
        let sign = value.polarity == .negative ? "-" : "+"
        let base = "\(sign)\(padded(hours)):\(padded(minutes))"
        return seconds == 0 ? base : "\(base):\(padded(seconds))"
    }
}

extension Affine.Translation where Domain == Time.Second {
    public init(hours: Int, minutes: Int = 0) throws(Difference.Error) {
        self = try Self.hours(hours, minutes: minutes)
    }

    public init(seconds: Int) {
        self = Self.seconds(seconds)
    }
}
