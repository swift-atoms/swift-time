extension Time.Hour {

    public enum Error {

        case invalidHour(Int)
    }
}

extension Time.Hour.Error: Swift.Error {}
extension Time.Hour.Error: Equatable {}
