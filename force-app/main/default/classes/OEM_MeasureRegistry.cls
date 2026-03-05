/**
 * Org Entropy Meter
 * Copyright 2026 Jyotishko Roy
 * Attribution: Jyotishko Roy (https://orcid.org/0009-0000-2837-4731)
 * Licensed under Apache-2.0 (see LICENSE).
 */

public class OEM_MeasureRegistry {
    public static List<IOEM_Measure> defaultMeasures() {
        return new List<IOEM_Measure>{
            new OEM_Measure_SetupAuditEvents7d(),
            new OEM_Measure_ActiveFlows(),
            new OEM_Measure_ActiveApexTriggers(),
            new OEM_Measure_PermissionSetAssignments(),
            new OEM_Measure_PermissionSets(),
            new OEM_Measure_DuplicateCustomFieldLabels(),
            new OEM_Measure_UndocumentedCustomFields(),
            new OEM_Measure_HotspotTriggerObjects()
        };
    }
}
