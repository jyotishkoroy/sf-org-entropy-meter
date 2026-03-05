/**
 * Org Entropy Meter
 * Copyright 2026 Jyotishko Roy
 * Attribution: Jyotishko Roy (https://orcid.org/0009-0000-2837-4731)
 * Licensed under Apache-2.0 (see LICENSE).
 */

public class OEM_Measure_HotspotTriggerObjects implements IOEM_Measure {
    public String key() { return 'HotspotTriggerObjects'; }
    public String domain() { return 'Hotspots'; }
    public OEM_MeasureConfig defaultConfig() {
        OEM_MeasureConfig c = OEM_MeasureConfig.defaults(domain(), key());
        c.greenMax = 2; c.yellowMax = 4; c.units = 'objects';
        return c;
    }
    public OEM_MeasureResult evaluate(OEM_DataProvider provider, OEM_MeasureConfig config) {
        Integer v = provider.countHotspotTriggerObjects(3);
        OEM_MeasureResult r = new OEM_MeasureResult();
        r.key = key(); r.domain = domain(); r.available = true; r.value = v;
        r.summary = 'Objects with 3+ triggers: ' + v;
        r.details = 'Hotspots concentrate complexity and failure cascades.';
        r.suggestedAction = 'Consolidate triggers and increase focused tests on hotspot objects.';
        r.helpUrl = 'https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_triggers.htm';
        return r;
    }
}
