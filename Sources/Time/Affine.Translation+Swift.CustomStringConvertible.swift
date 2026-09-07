import Tagged
import Polarity
import Magnitude
public import Affine
public import Difference
internal import Cardinal

extension Affine.Translation: @retroactive Swift.CustomStringConvertible where Domain == Time.Second {}
