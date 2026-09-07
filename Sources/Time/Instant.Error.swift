extension Instant {
    public enum Error {
        case nanosecondOutOfRange(Int32)
        case precision
        case overflow
        case conversion(Time.Conversion.Error)
    }
}

extension Instant.Error: Swift.Equatable {}

extension Instant.Error: Swift.Error {}
