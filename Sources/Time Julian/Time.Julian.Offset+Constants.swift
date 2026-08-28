public import Dimension

extension Tagged where Tag == Displacement.X<Time.Julian.Space>, Underlying == Double {

    public static let modified: Self = Self(2_400_000.5)
}
