extension Time.Instant {
    public enum Error {
        case nanosecondOutOfRange(Int32)
        case precision
        case overflow
        case conversion(Time.Conversion.Error)
    }
}

extension Time.Instant.Error: Swift.Equatable {}

extension Time.Instant.Error: Swift.Error {}
