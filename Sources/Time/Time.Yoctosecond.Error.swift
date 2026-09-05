extension Time.Yoctosecond {

    public enum Error {

        case invalidYoctosecond(Int)
    }
}

extension Time.Yoctosecond.Error: Swift.Error {}
extension Time.Yoctosecond.Error: Equatable {}
