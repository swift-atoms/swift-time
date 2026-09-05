extension Time.Second {

    public enum Error {

        case invalidSecond(Int)
    }
}

extension Time.Second.Error: Swift.Error {}
extension Time.Second.Error: Equatable {}
