extension Time.Picosecond {

    public enum Error {

        case invalidPicosecond(Int)
    }
}

extension Time.Picosecond.Error: Swift.Error {}
extension Time.Picosecond.Error: Equatable {}
