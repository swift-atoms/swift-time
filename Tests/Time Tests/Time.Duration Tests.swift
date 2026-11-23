import Testing
import Time

enum `Time.Duration Tests` {}

extension `Time.Duration Tests` {
    @Suite struct `A duration is a kind of quantity in seconds` {
        @Test func `Its dimension is time to the first power`() {
            #expect(Time.Duration.dimension == Quantity.Dimension(time: 1))
        }

        @Test func `An exact duration converts to seconds`() {
            let exact = Swift.Duration.milliseconds(1_500)
            #expect(Time.Duration.seconds(exact) == Time.Duration.seconds(1.5))
        }
    }
}
