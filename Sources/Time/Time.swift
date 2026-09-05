/// Calendar-independent temporal components, reference origins and arithmetic.
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
