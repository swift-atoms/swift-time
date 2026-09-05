/// Calendar-independent temporal components, reference origins and arithmetic.
public enum Time {}

extension Time {
    public static func totalNanoseconds(
        millisecond: Time.Millisecond,
        microsecond: Time.Microsecond,
        nanosecond: Time.Nanosecond
    ) -> Int {
        millisecond.value * 1_000_000 + microsecond.value * 1_000 + nanosecond.value
    }
}
