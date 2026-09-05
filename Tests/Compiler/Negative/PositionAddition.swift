// EXPECT-ERROR: binary operator|cannot convert|no exact matches
import Time
let origin = Instant(secondsSinceUnixEpoch: 0)
let invalid = origin + origin
