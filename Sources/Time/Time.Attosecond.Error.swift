extension Time.Attosecond {

    public enum Error {

        case invalidAttosecond(Int)
    }
}

extension Time.Attosecond.Error: Swift.Error {}
extension Time.Attosecond.Error: Equatable {}
