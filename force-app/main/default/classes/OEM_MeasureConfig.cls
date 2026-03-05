/**
 * Org Entropy Meter
 * Copyright 2026 Jyotishko Roy
 * Attribution: Jyotishko Roy (https://orcid.org/0009-0000-2837-4731)
 * Licensed under Apache-2.0 (see LICENSE).
 */

public class OEM_MeasureConfig {
    public String domain;
    public String key;
    public Decimal weight;
    public Decimal greenMax;
    public Decimal yellowMax;
    public String units;
    public Boolean enabled;

    public static OEM_MeasureConfig defaults(String domain, String key) {
        OEM_MeasureConfig c = new OEM_MeasureConfig();
        c.domain = domain;
        c.key = key;
        c.weight = 1;
        c.greenMax = 0;
        c.yellowMax = 1;
        c.enabled = true;
        return c;
    }
}
