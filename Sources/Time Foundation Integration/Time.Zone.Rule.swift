public import Foundation
public import Time

extension Time.Zone.Rule {

    public init(_ zone: Foundation.TimeZone) {
        self.init { instant in .seconds(zone.secondsFromGMT(for: Foundation.Date(instant))) }
    }
}
