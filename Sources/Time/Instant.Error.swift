public import Ratio

extension Instant {
    public enum Error {
        case nanosecondOutOfRange(Int32)
        case precision
        case overflow
        case conversion(Ratio::Failure)
    }
}

extension Instant.Error: Swift.Equatable {}

extension Instant.Error: Swift.Error {}
