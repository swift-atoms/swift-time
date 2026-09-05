extension Instant {

    @inlinable
    public static func milliseconds(from duration: Duration?) -> CInt {
        guard let duration else { return -1 }
        let ms = duration.attoseconds / 1_000_000_000_000_000
        return CInt(clamping: ms)
    }
}
