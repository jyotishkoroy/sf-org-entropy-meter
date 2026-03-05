/**
 * Org Entropy Meter
 * Copyright 2026 Jyotishko Roy
 * Attribution: Jyotishko Roy (https://orcid.org/0009-0000-2837-4731)
 * Licensed under Apache-2.0 (see LICENSE).
 */

public without sharing class OEM_OrgDataProvider implements OEM_DataProvider {
    public Integer countSetupAuditTrailLastDays(Integer days) {
        if (days == null || days <= 0) days = 7;
        DateTime cutoff = System.now().addDays(-days);
        return [SELECT COUNT() FROM SetupAuditTrail WHERE CreatedDate >= :cutoff];
    }
    public Integer countActiveFlows() {
        return [SELECT COUNT() FROM FlowDefinitionView WHERE ActiveVersionId != null];
    }
    public Integer countActiveApexTriggers() {
        return [SELECT COUNT() FROM ApexTrigger WHERE Status = 'Active'];
    }
    public Integer countPermissionSetAssignments() {
        return [SELECT COUNT() FROM PermissionSetAssignment WHERE Assignee.IsActive = true];
    }
    public Integer countPermissionSets() {
        return [SELECT COUNT() FROM PermissionSet];
    }
    public Integer countDuplicateCustomFieldLabels() {
        Map<String, Schema.SObjectType> g = Schema.getGlobalDescribe();
        Map<String, Integer> labelCount = new Map<String, Integer>();
        for (String apiName : g.keySet()) {
            Schema.DescribeSObjectResult d = g.get(apiName).getDescribe();
            if (!d.isCustom() || d.isCustomSetting()) continue;
            for (Schema.SObjectField f : d.fields.getMap().values()) {
                Schema.DescribeFieldResult fd = f.getDescribe();
                if (!fd.isCustom()) continue;
                String lbl = fd.getLabel();
                if (String.isBlank(lbl)) continue;
                String norm = lbl.trim().toLowerCase();
                labelCount.put(norm, (labelCount.containsKey(norm) ? labelCount.get(norm) + 1 : 1));
            }
        }
        Integer dup = 0;
        for (String k : labelCount.keySet()) {
            Integer c = labelCount.get(k);
            if (c != null && c >= 2) dup += (c - 1);
        }
        return dup;
    }
    public Integer countUndocumentedCustomFields() {
        Integer missing = 0;
        Map<String, Schema.SObjectType> g = Schema.getGlobalDescribe();
        for (String apiName : g.keySet()) {
            Schema.DescribeSObjectResult d = g.get(apiName).getDescribe();
            if (!d.isCustom() || d.isCustomSetting()) continue;
            for (Schema.SObjectField f : d.fields.getMap().values()) {
                Schema.DescribeFieldResult fd = f.getDescribe();
                if (!fd.isCustom()) continue;
                String help = fd.getInlineHelpText();
                String desc = fd.getDescription();
                if (String.isBlank(help) && String.isBlank(desc)) missing++;
            }
        }
        return missing;
    }
    public Integer countHotspotTriggerObjects(Integer minTriggerCount) {
        if (minTriggerCount == null || minTriggerCount <= 0) minTriggerCount = 3;
        List<AggregateResult> rows = [
            SELECT TableEnumOrId obj, COUNT(Id) c
            FROM ApexTrigger
            WHERE Status = 'Active'
            GROUP BY TableEnumOrId
        ];
        Integer hotspots = 0;
        for (AggregateResult ar : rows) {
            Integer c = (Integer)ar.get('c');
            if (c != null && c >= minTriggerCount) hotspots++;
        }
        return hotspots;
    }
}
