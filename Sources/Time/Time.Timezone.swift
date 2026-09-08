public import Translation

extension Time {
    /// A fixed UTC offset, represented as a temporal translation.
    /// This is not a database-backed timezone with daylight-saving rules.
    public typealias Zone = Translation<Time.Second.Offset>
    public typealias Timezone = Zone
}
