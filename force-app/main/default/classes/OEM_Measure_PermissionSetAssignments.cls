/**
 * Org Entropy Meter
 * Copyright 2026 Jyotishko Roy
 * Attribution: Jyotishko Roy (https://orcid.org/0009-0000-2837-4731)
 * Licensed under Apache-2.0 (see LICENSE).
 */

public class OEM_Measure_PermissionSetAssignments implements IOEM_Measure {
    public String key() { return 'PermissionSetAssignments'; }
    public String domain() { return 'Permission Sprawl'; }
    public OEM_MeasureConfig defaultConfig() {
        OEM_MeasureConfig c = OEM_MeasureConfig.defaults(domain(), key());
        c.greenMax = 200; c.yellowMax = 800; c.units = 'assignments';
        return c;
    }
    public OEM_MeasureResult evaluate(OEM_DataProvider provider, OEM_MeasureConfig config) {
        Integer v = provider.countPermissionSetAssignments();
        OEM_MeasureResult r = new OEM_MeasureResult();
        r.key = key(); r.domain = domain(); r.available = true; r.value = v;
        r.summary = 'Permission set assignments: ' + v;
        r.details = 'High assignment volumes can indicate ad-hoc privilege accrual.';
        r.suggestedAction = 'Consolidate bundles; run quarterly access reviews.';
        r.helpUrl = 'https://help.salesforce.com/s/articleView?id=sf.perm_set_overview.htm&type=5';
        return r;
    }
}
