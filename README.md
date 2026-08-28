# Time

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Calendar and timeline value types for Swift — absolute UTC `Time` with nanosecond precision, timeline `Instant` arithmetic, validated calendar components (year through yoctosecond), and the Gregorian calendar, with zero platform dependencies.

---

## Quick Start

`Time` is the namespace. Calendar components are *refinement types*: a month is constrained to 1–12, a day is validated against its month and year, so an impossible date cannot be constructed without an explicit error.

```swift
import Time

// Pre-validated components compose without throwing.
let year = Time.Year(2024)
let month = Time.Month.february
let day = try Time.Month.Day(29, in: month, year: year)   // valid only in a leap year

// Raw integers are validated; February 30 throws rather than silently wrapping.
let time = try Time(year: 2024, month: 2, day: 29, hour: 14, minute: 30, second: 0)
print(time.weekday)   // .thursday   (Zeller's congruence, no Foundation)
```

`Time` is the calendar view; `Instant` is the timeline view — an absolute point stored as seconds plus a nanosecond fraction since the Unix epoch. Convert between them and do timeline arithmetic with `Swift.Duration`:

```swift
let instant = Instant(time)
let later = instant + .seconds(3600)
let elapsed: Duration = later - instant   // .seconds(3600)

let backToCalendar = Time(later)
```

Epochs are first-class, so timestamps from different systems are unambiguous:

```swift
let unix = Time.Epoch.unix              // 1970-01-01
let gps = Time.Epoch.gps                // 1980-01-06
print(unix.referenceDate.year)          // 1970
```

The separate `swift-time-dimension` package provides `Time.Julian.Day` and `Time.Julian.Offset`:

```swift
import Time_Julian

let jd = Time.Julian.Day(time)          // continuous day count
let mjd = jd.modified                   // Modified Julian Day
```

The separate `swift-time-format` package provides automatic duration formatting:

```swift
import Time_Format

Duration.milliseconds(1500).formatted(.duration)               // "1.5 s"
Duration.microseconds(500).formatted(.duration)                // "500 µs"
Duration.milliseconds(1500).formatted(.duration.precision(2))  // "1.50 s"
```

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-atoms/swift-time.git", branch: "main")
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Time", package: "swift-time"),
    ]
)
```

Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the matching Linux / Windows toolchain).

---

## Architecture

The atom contains only the dependency-free Time domain. Cross-domain behavior is provided by focused molecule packages.

| Package | Product | Import | Purpose |
|---------|---------|--------|---------|
| `swift-time` | `Time` | `Time` | `Time`, `Instant`, calendar/timeline values, epochs, and the Gregorian calendar. |
| `swift-time-format` | `Time Format` | `Time_Format` | `Duration.formatted(_:)` and `Time.Format`. |
| `swift-time-dimension` | `Time Dimension` | `Time_Dimension` | `Time.Julian.Day`, `Time.Julian.Offset`, and conversions. |

The `Time` target imports no other Swift packages and uses no Foundation types — distinct calendar (`Time`) and timeline (`Instant`) representations stay distinct, rather than being conflated into a single `Date`.

---

## Platform Support

| Platform | Status |
|----------|--------|
| macOS 26 | Full support |
| Linux | Full support |
| Windows | Full support |
| iOS / tvOS / watchOS / visionOS | Supported |
| Swift Embedded | Partial (value types; `Codable` conformances excluded) |

Under Embedded Swift the calendar/timeline value types, arithmetic, and epochs are available. The `Codable` conformances on `Time`, `Instant`, and `Time.Timezone.Offset` are excluded under Embedded.

---

## Community

<!-- BEGIN: discussion -->
<!-- Discussion thread created at publication. -->
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
