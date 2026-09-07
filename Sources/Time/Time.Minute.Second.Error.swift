extension Time.Minute.Second {

    public enum Error {

        case invalidSecond(Int)
    }
}

extension Time.Minute.Second.Error: Swift.Equatable {}
