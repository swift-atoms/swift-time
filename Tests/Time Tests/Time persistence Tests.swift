import Foundation
import Rational
import Testing
import Time

@Suite struct `Temporal persistence retains exact numeric boundaries` {
    @Test func `elapsed quantities round trip decimal components beyond fixed width integers`() throws {
        let numerator = "-340282366920938463463374607431768211457"
        let denominator = "340282366920938463463374607431768211459"
        let bytes = Data("{\"numerator\":\"\(numerator)\",\"denominator\":\"\(denominator)\"}".utf8)
        let quantity = try JSONDecoder().decode(Time.Hour.self, from: bytes)
        let seconds = try quantity.converted(to: Time.Second.self)
        #expect(try seconds.converted(to: Time.Hour.self) == quantity)
        let encoded = try JSONEncoder().encode(quantity)
        let components = try JSONDecoder().decode([String: String].self, from: encoded)
        #expect(components == ["numerator": numerator, "denominator": denominator])
        #expect(try JSONDecoder().decode(Time.Hour.self, from: encoded) == quantity)
    }

    @Test func `zero quantities encode the canonical rational zero`() throws {
        let encoded = try JSONEncoder().encode(Time.Second.zero)
        #expect(try JSONDecoder().decode([String: String].self, from: encoded) == ["numerator": "0", "denominator": "1"])
    }

    @Test(arguments: ["{\"numerator\":\"1\",\"denominator\":\"0\"}", "{\"numerator\":\"NaN\",\"denominator\":\"1\"}", "{\"numerator\":\"Infinity\",\"denominator\":\"1\"}"])
    func `persisted quantities reject undefined and nonfinite components`(json: String) {
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(Time.Second.self, from: Data(json.utf8))
        }
    }

    @Test(arguments: [Int64.min, -1, 0, 1, Int64.max])
    func `unix positions round trip endpoint seconds with exact nanosecond fractions`(seconds: Int64) throws {
        let value = try Instant(secondsSinceUnixEpoch: seconds, nanosecondFraction: 999_999_999)
        let encoded = try JSONEncoder().encode(value)
        #expect(try JSONDecoder().decode(Instant.self, from: encoded) == value)
    }

    @Test func `arbitrary precision displacements report coordinate overflow without narrowing traps`() throws {
        let bytes = Data("{\"numerator\":\"340282366920938463463374607431768211457\",\"denominator\":\"1\"}".utf8)
        let displacement = try JSONDecoder().decode(Time.Nanosecond.self, from: bytes)
        let origin = Instant(secondsSinceUnixEpoch: 0)
        #expect(throws: Instant.Error.overflow) { try origin.advanced(by: displacement) }
        #expect(throws: Instant.Error.overflow) { try origin.advanced(by: -displacement) }
    }
}
