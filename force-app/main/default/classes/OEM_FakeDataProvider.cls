/**
 * Org Entropy Meter
 * Copyright 2026 Jyotishko Roy
 * Attribution: Jyotishko Roy (https://orcid.org/0009-0000-2837-4731)
 * Licensed under Apache-2.0 (see LICENSE).
 */

@IsTest
public class OEM_FakeDataProvider implements OEM_DataProvider {
    public Integer countSetupAuditTrailLastDays(Integer days) { return 10; }
    public Integer countActiveFlows() { return 50; }
    public Integer countActiveApexTriggers() { return 15; }
    public Integer countPermissionSetAssignments() { return 250; }
    public Integer countPermissionSets() { return 160; }
    public Integer countDuplicateCustomFieldLabels() { return 12; }
    public Integer countUndocumentedCustomFields() { return 9; }
    public Integer countHotspotTriggerObjects(Integer minTriggerCount) { return 2; }
}
