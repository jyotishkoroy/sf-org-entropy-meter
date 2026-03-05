/**
 * Org Entropy Meter
 * Copyright 2026 Jyotishko Roy
 * Attribution: Jyotishko Roy (https://orcid.org/0009-0000-2837-4731)
 * Licensed under Apache-2.0 (see LICENSE).
 */

public class OEM_Measure_SetupAuditEvents7d implements IOEM_Measure {
    public String key() { return 'SetupAuditEvents7d'; }
    public String domain() { return 'Change Velocity'; }
    public OEM_MeasureConfig defaultConfig() {
        OEM_MeasureConfig c = OEM_MeasureConfig.defaults(domain(), key());
        c.greenMax = 20; c.yellowMax = 60; c.units = 'events';
        return c;
    }
    public OEM_MeasureResult evaluate(OEM_DataProvider provider, OEM_MeasureConfig config) {
        Integer v = provider.countSetupAuditTrailLastDays(7);
        OEM_MeasureResult r = new OEM_MeasureResult();
        r.key = key(); r.domain = domain(); r.available = true; r.value = v;
        r.summary = 'Setup changes in last 7 days: ' + v;
        r.details = 'High change velocity increases drift risk.';
        r.suggestedAction = 'Consolidate changes into planned windows; document owners.';
        r.helpUrl = 'https://help.salesforce.com/s/articleView?id=sf.security_audit_trail.htm&type=5';
        return r;
    }
}
