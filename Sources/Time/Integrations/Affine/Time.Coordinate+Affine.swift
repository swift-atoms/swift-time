#if Affine
public import Affine
public import Coordinate
public import Tagged

extension Tagged
where
Tag == Time,
Underlying == Coordinate::Coordinate<1, Swift.Duration>
{

    public static var temporal: Affine<Self, Swift.Duration, Time.Instant.Error> {
        .init(
            translating: { (point, duration) throws(Time.Instant.Error) in
                let result = point.offset.attoseconds.addingReportingOverflow(duration.attoseconds)
                guard !result.overflow else { throw .overflow }
                return Self(offset: .init(attoseconds: result.partialValue))
            },
            displacement: { (start, end) throws(Time.Instant.Error) in
                let result = end.offset.attoseconds.subtractingReportingOverflow(start.offset.attoseconds)
                guard !result.overflow else { throw .overflow }
                return Swift.Duration(attoseconds: result.partialValue)
            }
        )
    }
}
#endif
