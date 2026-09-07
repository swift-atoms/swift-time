extension Time.Day.Hour {

    public enum Error {

        case invalidHour(Int)
    }
}

extension Time.Day.Hour.Error: Swift.Equatable {}

extension Time.Day.Hour.Error: Swift.Error {}
