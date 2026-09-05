// EXPECT-ERROR: cannot convert|conflicting arguments|requires the types
import Time
import Affine
import Tagged
import Difference
let origin = Instant(secondsSinceUnixEpoch: 0)
let invalid = try origin.position.advanced(by: Time.Minute.offset(Difference(1)))
