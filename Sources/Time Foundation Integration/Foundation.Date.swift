public import Foundation
public import Time

extension Foundation.Date {

    public init(_ instant: Time.Instant) {
        self.init(
            timeIntervalSince1970: Double(instant.secondsSinceUnixEpoch)
                + Double(instant.nanosecondFraction) / 1_000_000_000
        )
    }
}
