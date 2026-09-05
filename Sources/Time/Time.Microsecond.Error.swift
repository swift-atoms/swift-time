extension Time.Microsecond {

    public enum Error {

        case invalidMicrosecond(Int)
    }
}

extension Time.Microsecond.Error: Swift.Error {}
extension Time.Microsecond.Error: Equatable {}
