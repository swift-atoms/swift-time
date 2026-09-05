# swift-time

Calendar-independent temporal components, duration and instant arithmetic, fixed offsets,
and reference origins. This local experiment extracts civil calendar functionality into
`swift-calendar` and `swift-calendar-gregorian`.

All existing component types remain: Hour, Minute, Second, Millisecond, Microsecond,
Nanosecond, Picosecond, Femtosecond, Attosecond, Zeptosecond, and Yoctosecond. Their ranges
are unchanged. Fractional components remain base-1000 digits; Instant remains a Unix
seconds plus nanosecond-fraction representation. This extraction does not extend or
reduce Instant's precision, alter its arithmetic overflow behavior, or redesign codecs.

```swift
import Time

let fraction = try Time.Femtosecond(123)
let epoch = Time.Epoch(referenceDate: Instant(secondsSinceUnixEpoch: 0))
let instant = epoch.instant(after: .seconds(60))
assert(epoch.duration(to: instant) == .seconds(60))
```

`Time.Epoch<Reference>` preserves reference-date construction and value semantics without
requiring a particular calendar representation. Gregorian reference dates and all six
named epochs are provided by Calendar Gregorian. Named reference dates do not themselves
implement the corresponding time scales or wire formats.

The old root `Time` date-time value is now `Gregorian.DateTime`. `Time` remains
the namespace for the temporal atoms. See the Gregorian package's migration table for
calendar APIs. `Time Test Support` remains available. RFC consumers are not migrated by
this experiment.

## Generic requirements and isolation

`Time.Epoch<Reference>` imposes no Sendable, Equatable or Hashable requirement on its
reference. Those conformances are conditional on Reference. Local construction does
not transfer the reference or prevent continued local use of its aliases. An owner
receiving an epoch across an isolation boundary can accept `sending Time.Epoch<Reference>`.
The concurrency tests exercise this with a mutable, non-sendable reference.

Concrete integer-backed temporal atoms retain their checked Sendable conformances.
They impose no generic requirement on consumers and remain safe to share.
