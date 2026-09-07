public import Affine

extension Time {
    public typealias Zone = Affine.Translation<Time.Second>
    public typealias Timezone = Zone
}
