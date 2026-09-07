extension Time.Microsecond.Nanosecond {

    public enum Error {

        case invalidNanosecond(Int)
    }
}

extension Time.Microsecond.Nanosecond.Error: Swift.Equatable {}
