extension Time.Femtosecond.Attosecond {

    public enum Error {

        case invalidAttosecond(Int)
    }
}

extension Time.Femtosecond.Attosecond.Error: Swift.Equatable {}
