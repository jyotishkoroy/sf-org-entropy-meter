/**
 * Org Entropy Meter
 * Copyright 2026 Jyotishko Roy
 * Attribution: Jyotishko Roy (https://orcid.org/0009-0000-2837-4731)
 * Licensed under Apache-2.0 (see LICENSE).
 */

public class OEM_Measure_PermissionSets implements IOEM_Measure {
    public String key() { return 'PermissionSets'; }
    public String domain() { return 'Permission Sprawl'; }
    public OEM_MeasureConfig defaultConfig() {
        OEM_MeasureConfig c = OEM_MeasureConfig.defaults(domain(), key());
        c.weight = 0.6; c.greenMax = 120; c.yellowMax = 300; c.units = 'permsets';
        return c;
    }
    public OEM_MeasureResult evaluate(OEM_DataProvider provider, OEM_MeasureConfig config) {
        Integer v = provider.countPermissionSets();
        OEM_MeasureResult r = new OEM_MeasureResult();
        r.key = key(); r.domain = domain(); r.available = true; r.value = v;
        r.summary = 'Permission sets: ' + v;
        r.details = 'Large permset counts increase duplication and drift.';
        r.suggestedAction = 'Consolidate overlaps; enforce naming/ownership.';
        r.helpUrl = 'https://help.salesforce.com/s/articleView?id=sf.perm_sets.htm&type=5';
        return r;
    }
}
