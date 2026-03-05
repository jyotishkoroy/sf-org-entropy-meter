/**
 * Org Entropy Meter
 * Copyright 2026 Jyotishko Roy
 * Attribution: Jyotishko Roy (https://orcid.org/0009-0000-2837-4731)
 * Licensed under Apache-2.0 (see LICENSE).
 */

@IsTest
private class OEM_EntropyEngineTest {
    @IsTest
    static void computesEntropyIndex() {
        OEM_FakeDataProvider p = new OEM_FakeDataProvider();
        OEM_EntropyEngine.EngineResult er = OEM_EntropyEngine.run(p, OEM_MeasureRegistry.defaultMeasures());
        System.assertNotEquals(null, er);
        System.assert(er.entropyIndex >= 0 && er.entropyIndex <= 100);
        System.assert(er.results.size() > 0);
    }
}
