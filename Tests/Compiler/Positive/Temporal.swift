import Time
import Ratio
import Rational
import Tagged
import Difference
import Affine

let minutes = Time.Minute.quantity(90)
let doubled: Time.Minute.Quantity = try minutes.add.exact(minutes)
let hours: Time.Hour.Quantity = try Time.Conversion.quantity(doubled, to: Time.Hour.self)
let zero = Instant(secondsSinceUnixEpoch: 0)
let result: Instant = try zero.advanced(by: Time.Nanosecond.quantity(1))
let offset: Time.Zone.Offset = Time.Second.offset(Difference(-1800))
let zone = Time.Zone(offset: offset)
let translated = try zone.applying(to: zero.position)
