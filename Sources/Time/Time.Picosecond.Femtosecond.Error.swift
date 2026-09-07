extension Time.Picosecond.Femtosecond {

    public enum Error {

        case invalidFemtosecond(Int)
    }
}

extension Time.Picosecond.Femtosecond.Error: Swift.Equatable {}

extension Time.Picosecond.Femtosecond.Error: Swift.Error {}
