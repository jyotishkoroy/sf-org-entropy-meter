/**
 * Org Entropy Meter
 * Copyright 2026 Jyotishko Roy
 * Attribution: Jyotishko Roy (https://orcid.org/0009-0000-2837-4731)
 * Licensed under Apache-2.0 (see LICENSE).
 */

public class OEM_MeasureResult {
    public String key;
    public String domain;
    public Boolean available;
    public Decimal value;
    public Integer entropy;
    public String severity;

    public String summary;
    public String details;
    public String suggestedAction;
    public Integer delta;
    public String helpUrl;

    public static OEM_MeasureResult notAvailable(String key, String domain, String reason) {
        OEM_MeasureResult r = new OEM_MeasureResult();
        r.key = key; r.domain = domain; r.available = false;
        r.summary = 'Not available in this org context';
        r.details = reason;
        r.suggestedAction = 'Run as admin, or disable the measure in Custom Metadata.';
        r.severity = 'Info';
        return r;
    }
}
