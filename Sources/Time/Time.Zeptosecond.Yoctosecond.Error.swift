extension Time.Zeptosecond.Yoctosecond {

    public enum Error {

        case invalidYoctosecond(Int)
    }
}

extension Time.Zeptosecond.Yoctosecond.Error: Swift.Error {}
extension Time.Zeptosecond.Yoctosecond.Error: Equatable {}
