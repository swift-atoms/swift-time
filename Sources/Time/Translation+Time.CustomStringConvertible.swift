internal import Cardinal
import Magnitude
import Polarity
import Tagged
public import Translation

extension Translation: @retroactive Swift.CustomStringConvertible where Displacement == Time.Second.Offset {}
