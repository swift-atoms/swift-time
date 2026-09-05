extension Instant {

    public enum Error {

        case nanosecondOutOfRange(Int32)
    }
}

extension Instant.Error: Swift.Error {}
extension Instant.Error: Equatable {}
