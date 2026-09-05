# swift-time

Temporal components, exact unit quantities, timeline positions, fixed translations,
and reference origins. Calendar interpretation lives in `swift-calendar` and
`swift-calendar-gregorian`.

## Quantities and components

Elapsed quantities use the unit type directly. Clock components name their containing
unit: `Time.Day.Hour` (0...23), `Time.Hour.Minute` (0...59), and
`Time.Minute.Second` (0...60). Fractional components continue through
`Time.Second.Millisecond` to `Time.Zeptosecond.Yoctosecond`, each bounded to 0...999.

```swift
import Time

let minutes = Time.Minute(90)
let hours = try minutes.converted(to: Time.Hour.self) // exactly 3/2 hours
let total = try minutes + Time.Minute(15)             // 105 minutes
let fine = try Time.Second(1).converted(to: Time.Yoctosecond.self)
let minute = try Time.Hour.Minute(45)                // a clock component
```

Each quantity stores its exact signed `Rational` in `value`. Conversion, checked
arithmetic, comparison, and validated Codable handling share the `Time.Unit`
implementation. `Time.Quantity<Unit>` and `Unit.Quantity` alias the unit itself.
`Count` remains `Tagged<Unit, Cardinal>` and `Offset` remains
`Tagged<Unit, Difference>` for whole-unit counts and displacements.

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
let next = try origin + Time.Nanosecond(1)
let delta: Time.Nanosecond = origin.displacement(to: next)
let epoch = Time.Epoch(referenceDate: origin)
let restored = try epoch.instant(after: delta)
```

- `advanced(by: Quantity)` and `advanced(exactly: Swift.Duration)` report
  fractional nanoseconds or coordinate overflow instead of truncating.
- `displacement(to:)` represents the full minimum-to-maximum Instant distance.
- `duration(exactlyTo:)` uses Swift.Duration’s full attosecond representation,
  including the entire minimum-to-maximum Instant distance.
- Quantity operators (`instant + Time.Minute(90)` and quantity subtraction) throw
  on precision loss or overflow. InstantProtocol and Swift.Duration operators retain
  their nonthrowing signatures and exact-representability precondition.
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
let zone = try Time.Zone(hours: -5, minutes: 30)
let seconds = Time.Zone(seconds: -1)
assert(seconds.description == "-00:00:01")
```

Zone translation applies UTC-to-local; its inverse applies local-to-UTC.
Formatting retains negative subhour offsets and any seconds remainder. Gregorian's
`instant(in:)` and `gregorian(in:)` supply calendar interpretation.

The earlier `Time.Timezone.Offset(hours:minutes:)` construction becomes
`Time.Zone(hours:minutes:)`; `Offset(seconds:)` becomes `Time.Second.offset(...)`
when a displacement is needed or `Time.Zone(seconds: ...)` when a translation is
needed. Zones expose their displacement through `offset`.

Named geographical zones, transition databases, and leap-second tables are not
implemented by this fixed-translation value.

## Workspace

All package dependencies use URLs; `calendar-time.xcworkspace` supplies local
checkout overrides. Its scheme runs Time, Calendar, Gregorian, Affine, and Optic
tests. The workspace's `Checks/run.sh` verifies compile-time domain rejection.
