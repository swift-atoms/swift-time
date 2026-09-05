// EXPECT-ERROR: cannot convert|conflicting arguments|requires the types|binary operator
import Time
import Tagged
import Rational
let mixed = try Time.Second(1) + Time.Minute(1)
