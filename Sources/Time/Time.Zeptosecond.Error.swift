extension Time.Zeptosecond {

    public enum Error {

        case invalidZeptosecond(Int)
    }
}

extension Time.Zeptosecond.Error: Swift.Error {}
extension Time.Zeptosecond.Error: Equatable {}
