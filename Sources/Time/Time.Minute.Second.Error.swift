extension Time.Minute.Second {

    public enum Error {

        case invalidSecond(Int)
    }
}

extension Time.Minute.Second.Error: Swift.Error {}
extension Time.Minute.Second.Error: Equatable {}
