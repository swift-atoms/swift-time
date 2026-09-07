internal import Ratio

extension Time.Conversion {
    public enum Error: Swift.Error, Swift.Hashable, Swift.Sendable {
        case denominator
        case zeroFactor
        case negativeFactor
        case nonintegralFactor
        case overflow
        case inexact
        case unrepresentable
    }
}

extension Time.Conversion.Error {
    internal init<From, To>(_ error: Ratio<From, To>.Error) {
        switch error {
        case .denominator: self = .denominator
        case .zeroFactor: self = .zeroFactor
        case .negativeFactor: self = .negativeFactor
        case .nonintegralFactor: self = .nonintegralFactor
        case .overflow: self = .overflow
        case .inexact: self = .inexact
        case .unrepresentable: self = .unrepresentable
        }
    }
}
