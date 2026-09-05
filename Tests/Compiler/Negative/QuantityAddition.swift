// EXPECT-ERROR: cannot convert|conflicting arguments|requires the types|binary operator
import Time
import Tagged
import Rational
let mixed = Time.Second.quantity(1) + Time.Minute.quantity(1)
