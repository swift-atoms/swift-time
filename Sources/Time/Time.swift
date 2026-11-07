public import Coordinate
public import Tagged
public import Translation

public enum Time {}

extension Time {
    public static func totalNanoseconds(
        millisecond: Time.Second.Millisecond,
        microsecond: Time.Millisecond.Microsecond,
        nanosecond: Time.Microsecond.Nanosecond
    ) -> Int {
        millisecond.value * 1_000_000 + microsecond.value * 1_000 + nanosecond.value
    }
}

extension Time {

    public typealias Coordinate = Tagged<Time, Coordinate::Coordinate<1, Swift.Duration>>
}

extension Time {

    public typealias Zone = Translation<Time.Second.Offset>
    public typealias Timezone = Zone
}
