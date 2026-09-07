extension Time.Hour.Minute {

    public enum Error {

        case invalidMinute(Int)
    }
}

extension Time.Hour.Minute.Error: Swift.Equatable {}
