extension Time.Zone.Rule {
    public enum Policy {
        case earlier
        case later
    }
}

extension Time.Zone.Rule.Policy: Swift.Sendable {}

extension Time.Zone.Rule.Policy: Swift.Equatable {}

extension Time.Zone.Rule.Policy: Swift.Hashable {}
