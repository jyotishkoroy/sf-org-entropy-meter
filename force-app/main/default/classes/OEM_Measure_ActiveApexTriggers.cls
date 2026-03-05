/**
 * Org Entropy Meter
 * Copyright 2026 Jyotishko Roy
 * Attribution: Jyotishko Roy (https://orcid.org/0009-0000-2837-4731)
 * Licensed under Apache-2.0 (see LICENSE).
 */

public class OEM_Measure_ActiveApexTriggers implements IOEM_Measure {
    public String key() { return 'ActiveApexTriggers'; }
    public String domain() { return 'Automation Sprawl'; }
    public OEM_MeasureConfig defaultConfig() {
        OEM_MeasureConfig c = OEM_MeasureConfig.defaults(domain(), key());
        c.greenMax = 20; c.yellowMax = 60; c.units = 'triggers';
        return c;
    }
    public OEM_MeasureResult evaluate(OEM_DataProvider provider, OEM_MeasureConfig config) {
        Integer v = provider.countActiveApexTriggers();
        OEM_MeasureResult r = new OEM_MeasureResult();
        r.key = key(); r.domain = domain(); r.available = true; r.value = v;
        r.summary = 'Active Apex triggers: ' + v;
        r.details = 'High trigger counts increase coupling and release risk.';
        r.suggestedAction = 'Consolidate triggers using dispatcher patterns.';
        r.helpUrl = 'https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_triggers.htm';
        return r;
    }
}
