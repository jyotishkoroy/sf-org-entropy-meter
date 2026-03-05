/**
 * Org Entropy Meter
 * Copyright 2026 Jyotishko Roy
 * Attribution: Jyotishko Roy (https://orcid.org/0009-0000-2837-4731)
 * Licensed under Apache-2.0 (see LICENSE).
 */

public interface IOEM_Measure {
    String key();
    String domain();
    OEM_MeasureConfig defaultConfig();
    OEM_MeasureResult evaluate(OEM_DataProvider provider, OEM_MeasureConfig config);
}
