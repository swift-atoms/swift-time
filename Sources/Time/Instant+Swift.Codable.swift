#if !hasFeature(Embedded)
extension Instant: Swift.Codable {
        private enum CodingKeys: String, CodingKey {
            case secondsSinceUnixEpoch
            case nanosecondFraction
        }

        public init(from decoder: any Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            let seconds = try values.decode(Int64.self, forKey: .secondsSinceUnixEpoch)
            let fraction = try values.decode(Int32.self, forKey: .nanosecondFraction)
            do { try self.init(secondsSinceUnixEpoch: seconds, nanosecondFraction: fraction) }
            catch {
                throw DecodingError.dataCorruptedError(
                    forKey: .nanosecondFraction, in: values,
                    debugDescription: "An Instant fraction must be in 0..<1,000,000,000"
                )
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var values = encoder.container(keyedBy: CodingKeys.self)
            try values.encode(secondsSinceUnixEpoch, forKey: .secondsSinceUnixEpoch)
            try values.encode(nanosecondFraction, forKey: .nanosecondFraction)
        }
    }
#endif
