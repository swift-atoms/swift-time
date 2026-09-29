public import Foundation
public import Time

extension Time.Instant {

    public init(_ date: Foundation.Date) throws(Time.Instant.Error) {
        let interval = date.timeIntervalSince1970
        guard interval.isFinite else { throw .overflow }
        let floored = interval.rounded(.down)
        guard let seconds = Int64(exactly: floored) else { throw .overflow }
        let nanoseconds = ((interval - floored) * 1_000_000_000).rounded()
        let (carried, overflow) = nanoseconds == 1_000_000_000
            ? seconds.addingReportingOverflow(1)
            : (seconds, false)
        guard !overflow else { throw .overflow }
        try self.init(
            secondsSinceUnixEpoch: carried,
            nanosecondFraction: nanoseconds == 1_000_000_000 ? 0 : Int32(nanoseconds)
        )
    }
}
