public import Affine

extension Time {
    /// A fixed translation from Unix coordinates to local clock coordinates.
    /// Named geographical zones and transition databases have a separate contract.
    public typealias Zone = Affine.Translation<Time.Second>
    public typealias Timezone = Zone
}
