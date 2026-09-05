extension Time.Nanosecond {

    public enum Error {

        case invalidNanosecond(Int)
    }
}

extension Time.Nanosecond.Error: Swift.Error {}
extension Time.Nanosecond.Error: Equatable {}
