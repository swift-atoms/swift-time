// EXPECT-ERROR: operator function.*requires that 'Instant' conform to 'Time.Unit'
import Time
let origin = Instant(secondsSinceUnixEpoch: 0)
let invalid = origin + origin
