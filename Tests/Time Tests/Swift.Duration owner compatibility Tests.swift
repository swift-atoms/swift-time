import Testing
import Time

@Suite struct `Duration owner retains compatibility` {
    private func throughProtocol<D: Time::Duration.`Protocol`>(
        _ value: D
    ) -> D { value }

    @Test func `the qualified duration alias retains native identity through the owner`() {
        let qualified: Time::Duration = .milliseconds(-1250)
        let native: Swift.Duration = throughProtocol(qualified)
        let unqualified: Duration = native
        #expect(
            ObjectIdentifier(Time::Duration.self)
                == ObjectIdentifier(Swift.Duration.self)
        )
        #expect(unqualified == .milliseconds(-1250))
        #expect(unqualified.inSeconds == -1.25)
        #expect(unqualified.inMilliseconds == -1250)
        #expect(unqualified.inMicroseconds == -1_250_000)
        #expect(unqualified.inNanoseconds == -1_250_000_000)
    }

    @Test func `duration owner conversions include the native storage boundary`() {
        let duration = Time::Duration(attoseconds: .max)
        #expect(duration.inSeconds.bitPattern == 0x4422_725d_d1d2_43ac)
        #expect(duration.inMilliseconds.bitPattern == 0x44c2_03af_9ee7_5616)
        #expect(duration.inMicroseconds.bitPattern == 0x4561_9799_812d_ea11)
        #expect(duration.inNanoseconds.bitPattern == 0x4601_2e0b_e826_d695)
    }
}
