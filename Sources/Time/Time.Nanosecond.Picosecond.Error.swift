extension Time.Nanosecond.Picosecond {

    public enum Error {

        case invalidPicosecond(Int)
    }
}

extension Time.Nanosecond.Picosecond.Error: Swift.Error {}
extension Time.Nanosecond.Picosecond.Error: Equatable {}
