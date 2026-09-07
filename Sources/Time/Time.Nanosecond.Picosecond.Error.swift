extension Time.Nanosecond.Picosecond {

    public enum Error {

        case invalidPicosecond(Int)
    }
}

extension Time.Nanosecond.Picosecond.Error: Swift.Equatable {}

extension Time.Nanosecond.Picosecond.Error: Swift.Error {}
