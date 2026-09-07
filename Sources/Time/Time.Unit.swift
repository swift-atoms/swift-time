public import Cardinal
public import Difference
public import Rational
public import Ratio
public import Tagged
internal import Polarity

extension Time {
    public protocol Unit {
        static var seconds: Ratio<Self, Time.Second> { get }
        var value: Rational { get }
        init(_ value: Rational)
    }

    public typealias Quantity<Unit: Time.Unit> = Unit
    public typealias Count<Unit> = Tagged<Unit, Cardinal>
    public typealias Offset<Unit> = Tagged<Unit, Difference>

}

extension Time.Unit {
    public typealias Quantity = Time.Quantity<Self>
    public typealias Count = Time.Count<Self>
    public typealias Offset = Time.Offset<Self>

    public init(_ value: Int128) { self.init(Rational(value)) }

    public static var zero: Self { Self(Rational.zero) }

    public func converted<To: Time.Unit>(to: To.Type) throws(Ratio::Failure) -> To {
        try Time.Conversion.quantity(self, to: to)
    }

    public static prefix func - (value: Self) -> Self { Self(-value.value) }

    public static func + (lhs: Self, rhs: Self) throws(Rational.Error) -> Self {
        Self(try lhs.value.adding(rhs.value))
    }

    public static func - (lhs: Self, rhs: Self) throws(Rational.Error) -> Self {
        Self(try lhs.value.subtracting(rhs.value))
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
        To(try ratio(from: From.self, to: To.self).applying(to: value.value))
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
    static func scale<From, To>(
        numerator: UInt128, denominator: UInt128 = 1
    ) -> Ratio<From, To> {
        do { return try Ratio(numerator: numerator, denominator: denominator) }
        catch { preconditionFailure("The temporal unit scale is representable") }
    }
}

extension Time.Unit {
    public static func < (lhs: Self, rhs: Self) -> Bool { lhs.value < rhs.value }
}

#if !hasFeature(Embedded)
extension Time.Unit {
    public init(from decoder: any Decoder) throws {
        self.init(try Rational(from: decoder))
    }

    public func encode(to encoder: any Encoder) throws {
        try value.encode(to: encoder)
    }
}
#endif
