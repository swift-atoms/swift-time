import Testing
import Time

private final class LocalReference {
    var value: Int
    init(_ value: Int) { self.value = value }
}

private struct EqualityOnly: Equatable {
    let value: Int
}

private actor EpochReceiver {
    private var epoch: Time.Epoch<LocalReference>?

    func store(_ epoch: sending Time.Epoch<LocalReference>) {
        self.epoch = epoch
    }

    func value() -> Int? { epoch?.referenceDate.value }
}

private func makeLocalEpoch() -> sending Time.Epoch<LocalReference> {
    Time.Epoch(referenceDate: LocalReference(42))
}

private func requireSendable<T: Sendable>(_ value: T) {}

@Suite struct EpochIsolationTests {
    @Test func localConstructionDoesNotRequireTransferOrConformances() {
        let reference = LocalReference(1)
        let epoch = Time.Epoch(referenceDate: reference)
        // The initializer must not consume the reference's isolation region.
        reference.value = 2
        #expect(epoch.referenceDate === reference)
        #expect(epoch.referenceDate.value == 2)
    }

    @Test func equalityIsIndependentOfHashability() {
        let a = Time.Epoch(referenceDate: EqualityOnly(value: 1))
        let b = Time.Epoch(referenceDate: EqualityOnly(value: 1))
        #expect(a == b)
    }

    @Test func conditionalConformancesRemainAvailable() {
        let epoch = Time.Epoch(referenceDate: Instant(secondsSinceUnixEpoch: 0))
        requireSendable(epoch)
        #expect(Set([epoch, epoch]).count == 1)
    }

    @Test func disconnectedNonSendableReferenceCanBeSentToAnActor() async {
        let receiver = EpochReceiver()
        let epoch = makeLocalEpoch()
        await receiver.store(epoch)
        #expect(await receiver.value() == 42)
    }
}
