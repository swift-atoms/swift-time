extension Time.Minute {

    public enum Error {

        case invalidMinute(Int)
    }
}

extension Time.Minute.Error: Swift.Error {}
extension Time.Minute.Error: Equatable {}
