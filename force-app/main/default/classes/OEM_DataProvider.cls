/**
 * Org Entropy Meter
 * Copyright 2026 Jyotishko Roy
 * Attribution: Jyotishko Roy (https://orcid.org/0009-0000-2837-4731)
 * Licensed under Apache-2.0 (see LICENSE).
 */

public interface OEM_DataProvider {
    Integer countSetupAuditTrailLastDays(Integer days);
    Integer countActiveFlows();
    Integer countActiveApexTriggers();
    Integer countPermissionSetAssignments();
    Integer countPermissionSets();
    Integer countDuplicateCustomFieldLabels();
    Integer countUndocumentedCustomFields();
    Integer countHotspotTriggerObjects(Integer minTriggerCount);
}
