extension Time.Millisecond.Microsecond {

    public enum Error {

        case invalidMicrosecond(Int)
    }
}

extension Time.Millisecond.Microsecond.Error: Swift.Error {}
extension Time.Millisecond.Microsecond.Error: Equatable {}
