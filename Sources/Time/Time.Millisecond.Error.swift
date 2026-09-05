extension Time.Millisecond {

    public enum Error {

        case invalidMillisecond(Int)
    }
}

extension Time.Millisecond.Error: Swift.Error {}
extension Time.Millisecond.Error: Equatable {}
