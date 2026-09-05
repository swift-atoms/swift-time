public import Cardinal
public import Difference
public import Rational
public import Ratio
public import Tagged
internal import Polarity

extension Time {
    /// A scale for elapsed quantities, independently of a bounded clock component.
    /// A unit's seconds scale must remain stable and strictly positive.
    public protocol Unit {
        static var seconds: Ratio<Self, Time.Second> { get }
    }

    public typealias Quantity<Unit> = Tagged<Unit, Rational>
    public typealias Count<Unit> = Tagged<Unit, Cardinal>
    public typealias Offset<Unit> = Tagged<Unit, Difference>

    /// The uniform unit of 86,400 seconds; calendar-day advancement is separate.
    public enum Day {}
}

extension Time.Unit {
    public typealias Quantity = Time.Quantity<Self>
    public typealias Count = Time.Count<Self>
    public typealias Offset = Time.Offset<Self>

    public static func quantity(_ value: Int128) -> Quantity {
        Quantity(Rational(value))
    }

    @_disfavoredOverload
    public static func quantity(_ value: Rational) -> Quantity {
        Quantity(value)
    }

    public static func count(_ value: Cardinal) -> Count {
        Count(value)
    }

    public static func offset(_ value: Difference) -> Offset {
        Offset(value)
    }
}

extension Time.Conversion {
    public static func ratio<From: Time.Unit, To: Time.Unit>(
        from: From.Type, to: To.Type
    ) throws(Ratio::Failure) -> Ratio<From, To> {
        let source = From.seconds
        let target = To.seconds
        guard source.polarity != nil && target.polarity != nil else { throw .zeroFactor }
        guard source.polarity == .positive && target.polarity == .positive else {
            throw .negativeFactor
        }
        return try source.composed(with: target.inverted())
    }

    public static func quantity<From: Time.Unit, To: Time.Unit>(
        _ value: Time.Quantity<From>, to: To.Type
    ) throws(Ratio::Failure) -> Time.Quantity<To> {
        try ratio(from: From.self, to: To.self).applying(to: value)
    }

    public static func count<From: Time.Unit, To: Time.Unit>(
        _ value: Time.Count<From>, to: To.Type
    ) throws(Ratio::Failure) -> Time.Count<To> {
        try ratio(from: From.self, to: To.self).applying(to: value)
    }

    public static func offset<From: Time.Unit, To: Time.Unit>(
        _ value: Time.Offset<From>, to: To.Type
    ) throws(Ratio::Failure) -> Time.Offset<To> {
        try ratio(from: From.self, to: To.self).applying(to: value)
    }
}


extension Time.Conversion {
    /// Constructs the fixed, positive scale constants used by temporal units.
    static func scale<From, To>(
        numerator: UInt128, denominator: UInt128 = 1
    ) -> Ratio<From, To> {
        do { return try Ratio(numerator: numerator, denominator: denominator) }
        catch { preconditionFailure("The temporal unit scale is representable") }
    }
}
