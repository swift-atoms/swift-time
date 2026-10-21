import Testing
import Time

@Suite struct `Duration conversions preserve native semantics` {
    private func throughProtocol<D: Time::Duration.`Protocol`>(_ value: D) -> D { value }

    @Test func `the duration alias retains native identity and its protocol constraint`() {
        let value: Time::Duration = .milliseconds(1250)
        let native: Swift.Duration = throughProtocol(value)
        let unqualified: Duration = native
        #expect(ObjectIdentifier(Time::Duration.self) == ObjectIdentifier(Swift.Duration.self))
        #expect(unqualified == .milliseconds(1250))
    }

    @Test(arguments: [
        (Swift.Duration.zero, 0.0, 0.0, 0.0, 0.0),
        (.seconds(2), 2.0, 2000.0, 2_000_000.0, 2_000_000_000.0),
        (.seconds(-2), -2.0, -2000.0, -2_000_000.0, -2_000_000_000.0),
        (.milliseconds(1250), 1.25, 1250.0, 1_250_000.0, 1_250_000_000.0),
        (.milliseconds(-1250), -1.25, -1250.0, -1_250_000.0, -1_250_000_000.0),
        (
            .init(secondsComponent: 1, attosecondsComponent: -500_000_000_000_000_000),
            0.5, 500.0, 500_000.0, 500_000_000.0
        ),
        (
            .init(secondsComponent: -1, attosecondsComponent: 500_000_000_000_000_000),
            -0.5, -500.0, -500_000.0, -500_000_000.0
        ),
    ])
    func `unit conversions preserve signed and fractional durations`(
        duration: Swift.Duration,
        seconds: Double,
        milliseconds: Double,
        microseconds: Double,
        nanoseconds: Double
    ) {
        #expect(duration.inSeconds == seconds)
        #expect(duration.inMilliseconds == milliseconds)
        #expect(duration.inMicroseconds == microseconds)
        #expect(duration.inNanoseconds == nanoseconds)
    }

    @Test(arguments: [Int128(1), -1])
    func `one attosecond retains its sign below nanosecond precision`(attoseconds: Int128) {
        let duration = Swift.Duration(attoseconds: attoseconds)
        let sign = attoseconds > 0 ? 1.0 : -1.0
        #expect(duration.inSeconds == sign * 1e-18)
        #expect(duration.inMilliseconds == sign * 1e-15)
        #expect(duration.inMicroseconds == sign * 1e-12)
        #expect(duration.inNanoseconds == sign * 1e-9)
    }

    @Test(arguments: [
        (
            Int128.max, UInt64(0x4422_725d_d1d2_43ac), UInt64(0x44c2_03af_9ee7_5616),
            UInt64(0x4561_9799_812d_ea11), UInt64(0x4601_2e0b_e826_d695)
        ),
        (
            Int128.min, UInt64(0xc422_725d_d1d2_43ac), UInt64(0xc4c2_03af_9ee7_5616),
            UInt64(0xc561_9799_812d_ea11), UInt64(0xc601_2e0b_e826_d695)
        ),
    ])
    func `native duration boundaries retain their floating point conversions`(
        attoseconds: Int128,
        seconds: UInt64,
        milliseconds: UInt64,
        microseconds: UInt64,
        nanoseconds: UInt64
    ) {
        let duration = Swift.Duration(attoseconds: attoseconds)
        #expect(duration.inSeconds.bitPattern == seconds)
        #expect(duration.inMilliseconds.bitPattern == milliseconds)
        #expect(duration.inMicroseconds.bitPattern == microseconds)
        #expect(duration.inNanoseconds.bitPattern == nanoseconds)
    }
}
