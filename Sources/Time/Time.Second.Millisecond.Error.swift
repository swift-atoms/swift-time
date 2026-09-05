extension Time.Second.Millisecond {

    public enum Error {

        case invalidMillisecond(Int)
    }
}

extension Time.Second.Millisecond.Error: Swift.Error {}
extension Time.Second.Millisecond.Error: Equatable {}
