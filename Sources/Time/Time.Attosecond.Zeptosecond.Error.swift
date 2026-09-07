extension Time.Attosecond.Zeptosecond {

    public enum Error {

        case invalidZeptosecond(Int)
    }
}

extension Time.Attosecond.Zeptosecond.Error: Swift.Equatable {}
