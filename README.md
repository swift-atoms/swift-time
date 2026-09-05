# swift-time

Temporal components, exact unit quantities, timeline positions, fixed translations,
and reference origins. Calendar interpretation lives in `swift-calendar` and
`swift-calendar-gregorian`.

## Quantities and components

All eleven bounded component types remain: Hour, Minute, Second, Millisecond,
Microsecond, Nanosecond, Picosecond, Femtosecond, Attosecond, Zeptosecond, and
Yoctosecond. Their validation ranges are unchanged. A fractional component is a
base-1000 digit; it is distinct from an unrestricted quantity in that unit.

Each unit exposes three roles:

- `Quantity` is `Tagged<Unit, Rational>` for exact signed fractional quantities.
- `Count` is `Tagged<Unit, Cardinal>` for nonnegative whole-unit counts.
- `Offset` is `Tagged<Unit, Difference>` for signed whole-unit displacements.

```swift
import Time
import Ratio
import Rational
import Tagged

let minutes = Time.Minute.quantity(90)
let hours = try Time.Conversion.quantity(minutes, to: Time.Hour.self)
// hours.underlying == 3/2
let total = try minutes.add.exact(minutes)
let fine = try Time.Conversion.quantity(Time.Second.quantity(1), to: Time.Yoctosecond.self)
// fine.underlying == 10^24, exactly
```

`Time.Conversion.ratio(from:to:)` composes unit scales. `quantity(_:to:)`
preserves exact fractional values. `count(_:to:)` and `offset(_:to:)` require an
integral representable result and throw for inexactness or overflow. Rational
numerators and denominators use UInt128; this supports every existing fractional
unit without implying unbounded numeric storage.

`Time.Day` denotes a uniform elapsed unit of 86,400 seconds. Calendar-day
advancement has a separate domain. Uniform clock decomposition reuses Division's
Euclidean quotient and carries the day count for negative coordinates.

## Instants and origins

`Instant` stores `Affine.Position<Time.Second>` plus a validated nanosecond
fraction. Quantities may be finer than an Instant's representable precision.

```swift
let origin = Instant(secondsSinceUnixEpoch: 0)
let next = try origin.advanced(by: Time.Nanosecond.quantity(1))
let delta: Time.Nanosecond.Quantity = origin.displacement(to: next)
let epoch = Time.Epoch(referenceDate: origin)
let restored = try epoch.instant(after: delta)
```

- `advanced(by: Quantity)` and `advanced(exactly: Swift.Duration)` report
  fractional nanoseconds or coordinate overflow instead of truncating.
- `displacement(to:)` represents the full minimum-to-maximum Instant distance.
- `duration(exactlyTo:)` uses Swift.Duration’s full attosecond representation,
  including the entire minimum-to-maximum Instant distance.
- InstantProtocol and ordinary operators retain their nonthrowing signatures;
  their precondition is exact representability. Use the checked APIs at boundaries.
  Duration integration reads its full-width attoseconds without narrowing through
  an Int64 seconds projection.
- Codable decoding revalidates the fraction. The Unix seconds/fraction wire
  representation is unchanged.

`Time.Epoch<Reference>` has no unconditional Sendable, Equatable, or Hashable
requirement. Conformances are conditional on Reference. Gregorian supplies the six
named civil reference dates. Names alone do not implement UTC/TAI/GPS leap-scale
conversion.

## Fixed zones

`Time.Zone` aliases `Affine.Translation<Time.Second>`. Consequently,
`Time.Zone.Offset` is the shared `Tagged<Time.Second, Difference>` type.
`Time.Timezone` is another spelling of the same fixed translation.

```swift
let zone = try Time.Zone.hours(-5, minutes: 30)
let seconds = Time.Zone.seconds(-1)
assert(seconds.description == "-00:00:01")
```

Zone translation applies UTC-to-local; its inverse applies local-to-UTC.
Formatting retains negative subhour offsets and any seconds remainder. Gregorian's
`instant(in:)` and `gregorian(in:)` supply calendar interpretation.

The earlier `Time.Timezone.Offset(hours:minutes:)` construction becomes
`Time.Zone.hours(_:minutes:)`; `Offset(seconds:)` becomes `Time.Second.offset(...)`
when a displacement is needed or `Time.Zone.seconds(...)` when a translation is
needed. Zones expose their displacement through `offset`.

Named geographical zones, transition databases, and leap-second tables are not
implemented by this fixed-translation value.

## Workspace

All package dependencies use URLs; `calendar-time.xcworkspace` supplies local
checkout overrides. Its scheme runs Time, Calendar, Gregorian, Affine, and Optic
tests. The workspace's `Checks/run.sh` verifies compile-time domain rejection.
