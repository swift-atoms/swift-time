import Tagged
import Polarity
import Magnitude
public import Translation
internal import Cardinal

extension Translation: @retroactive Swift.CustomStringConvertible where Displacement == Time.Second.Offset {}
