extension Time.Second.Millisecond {

    public enum Error {

        case invalidMillisecond(Int)
    }
}

extension Time.Second.Millisecond.Error: Swift.Equatable {}

extension Time.Second.Millisecond.Error: Swift.Error {}
