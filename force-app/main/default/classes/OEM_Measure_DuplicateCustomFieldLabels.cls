/**
 * Org Entropy Meter
 * Copyright 2026 Jyotishko Roy
 * Attribution: Jyotishko Roy (https://orcid.org/0009-0000-2837-4731)
 * Licensed under Apache-2.0 (see LICENSE).
 */

public class OEM_Measure_DuplicateCustomFieldLabels implements IOEM_Measure {
    public String key() { return 'DuplicateCustomFieldLabels'; }
    public String domain() { return 'Duplication'; }
    public OEM_MeasureConfig defaultConfig() {
        OEM_MeasureConfig c = OEM_MeasureConfig.defaults(domain(), key());
        c.greenMax = 10; c.yellowMax = 50; c.units = 'labels';
        return c;
    }
    public OEM_MeasureResult evaluate(OEM_DataProvider provider, OEM_MeasureConfig config) {
        Integer v = provider.countDuplicateCustomFieldLabels();
        OEM_MeasureResult r = new OEM_MeasureResult();
        r.key = key(); r.domain = domain(); r.available = true; r.value = v;
        r.summary = 'Duplicate custom field labels (estimated): ' + v;
        r.details = 'Duplicate labels often signal overlapping concepts.';
        r.suggestedAction = 'Standardize naming; deprecate duplicates; improve governance.';
        r.helpUrl = 'https://help.salesforce.com/s/articleView?id=sf.fields_about_field_definitions.htm&type=5';
        return r;
    }
}
