extension Time.Femtosecond {

    public enum Error {

        case invalidFemtosecond(Int)
    }
}

extension Time.Femtosecond.Error: Swift.Error {}
extension Time.Femtosecond.Error: Equatable {}
