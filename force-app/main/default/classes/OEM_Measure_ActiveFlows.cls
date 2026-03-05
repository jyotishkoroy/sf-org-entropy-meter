/**
 * Org Entropy Meter
 * Copyright 2026 Jyotishko Roy
 * Attribution: Jyotishko Roy (https://orcid.org/0009-0000-2837-4731)
 * Licensed under Apache-2.0 (see LICENSE).
 */

public class OEM_Measure_ActiveFlows implements IOEM_Measure {
    public String key() { return 'ActiveFlows'; }
    public String domain() { return 'Automation Sprawl'; }
    public OEM_MeasureConfig defaultConfig() {
        OEM_MeasureConfig c = OEM_MeasureConfig.defaults(domain(), key());
        c.greenMax = 80; c.yellowMax = 200; c.units = 'flows';
        return c;
    }
    public OEM_MeasureResult evaluate(OEM_DataProvider provider, OEM_MeasureConfig config) {
        Integer v = provider.countActiveFlows();
        OEM_MeasureResult r = new OEM_MeasureResult();
        r.key = key(); r.domain = domain(); r.available = true; r.value = v;
        r.summary = 'Active flows: ' + v;
        r.details = 'Automation sprawl increases cognitive load and conflicts.';
        r.suggestedAction = 'Archive unused flows; standardize naming; assign ownership.';
        r.helpUrl = 'https://help.salesforce.com/s/articleView?id=sf.flow.htm&type=5';
        return r;
    }
}
