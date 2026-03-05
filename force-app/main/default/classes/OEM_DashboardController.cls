/**
 * Org Entropy Meter
 * Copyright 2026 Jyotishko Roy
 * Attribution: Jyotishko Roy (https://orcid.org/0009-0000-2837-4731)
 * Licensed under Apache-2.0 (see LICENSE).
 */

public with sharing class OEM_DashboardController {
    public class SnapshotDTO {
        @AuraEnabled public Id id;
        @AuraEnabled public Datetime snapshotDate;
        @AuraEnabled public String status;
        @AuraEnabled public Integer entropyIndex;
        @AuraEnabled public Integer changeVelocity;
        @AuraEnabled public Integer automationSprawl;
        @AuraEnabled public Integer permissionSprawl;
        @AuraEnabled public Integer duplication;
        @AuraEnabled public Integer hotspots;
        @AuraEnabled public Integer measuresAvailable;
        @AuraEnabled public Integer measuresTotal;
        @AuraEnabled public String orgName;
    }
    public class TrendPointDTO { @AuraEnabled public Datetime x; @AuraEnabled public Integer y; }
    public class FindingDTO {
        @AuraEnabled public Id id;
        @AuraEnabled public String domain;
        @AuraEnabled public String measureKey;
        @AuraEnabled public String severity;
        @AuraEnabled public Integer entropyContribution;
        @AuraEnabled public Integer delta;
        @AuraEnabled public String summary;
        @AuraEnabled public String helpUrl;
    }

    @AuraEnabled(cacheable=true)
    public static SnapshotDTO getLatestSnapshot() {
        List<OEM_Entropy_Snapshot__c> snaps = [
            SELECT Id, SnapshotDate__c, Status__c, EntropyIndex__c,
                   ChangeVelocity__c, AutomationSprawl__c, PermissionSprawl__c, Duplication__c, Hotspots__c,
                   MeasuresAvailable__c, MeasuresTotal__c, OrgName__c
            FROM OEM_Entropy_Snapshot__c
            WHERE Status__c IN ('Completed','Partial')
            ORDER BY SnapshotDate__c DESC
            LIMIT 1
        ];
        if (snaps.isEmpty()) return null;
        OEM_Entropy_Snapshot__c s = snaps[0];
        SnapshotDTO d = new SnapshotDTO();
        d.id = s.Id;
        d.snapshotDate = s.SnapshotDate__c;
        d.status = s.Status__c;
        d.entropyIndex = (s.EntropyIndex__c == null ? 0 : Integer.valueOf(s.EntropyIndex__c));
        d.changeVelocity = (s.ChangeVelocity__c == null ? 0 : Integer.valueOf(s.ChangeVelocity__c));
        d.automationSprawl = (s.AutomationSprawl__c == null ? 0 : Integer.valueOf(s.AutomationSprawl__c));
        d.permissionSprawl = (s.PermissionSprawl__c == null ? 0 : Integer.valueOf(s.PermissionSprawl__c));
        d.duplication = (s.Duplication__c == null ? 0 : Integer.valueOf(s.Duplication__c));
        d.hotspots = (s.Hotspots__c == null ? 0 : Integer.valueOf(s.Hotspots__c));
        d.measuresAvailable = (s.MeasuresAvailable__c == null ? null : Integer.valueOf(s.MeasuresAvailable__c));
        d.measuresTotal = (s.MeasuresTotal__c == null ? null : Integer.valueOf(s.MeasuresTotal__c));
        d.orgName = s.OrgName__c;
        return d;
    }

    @AuraEnabled(cacheable=true)
    public static List<TrendPointDTO> getTrend(Integer days) {
        if (days == null || days <= 0) days = 30;
        DateTime cutoff = System.now().addDays(-days);
        List<TrendPointDTO> out = new List<TrendPointDTO>();
        for (OEM_Entropy_Snapshot__c s : [
            SELECT SnapshotDate__c, EntropyIndex__c
            FROM OEM_Entropy_Snapshot__c
            WHERE Status__c IN ('Completed','Partial') AND SnapshotDate__c >= :cutoff
            ORDER BY SnapshotDate__c ASC
        ]) {
            TrendPointDTO p = new TrendPointDTO();
            p.x = s.SnapshotDate__c;
            p.y = (s.EntropyIndex__c == null ? 0 : Integer.valueOf(s.EntropyIndex__c));
            out.add(p);
        }
        return out;
    }

    @AuraEnabled(cacheable=true)
    public static List<FindingDTO> getAlerts(Id snapshotId, Integer limitSize) {
        if (limitSize == null || limitSize <= 0 || limitSize > 200) limitSize = 50;
        if (snapshotId == null) {
            List<OEM_Entropy_Snapshot__c> snaps = [SELECT Id FROM OEM_Entropy_Snapshot__c WHERE Status__c IN ('Completed','Partial') ORDER BY SnapshotDate__c DESC LIMIT 1];
            if (snaps.isEmpty()) return new List<FindingDTO>();
            snapshotId = snaps[0].Id;
        }
        List<FindingDTO> out = new List<FindingDTO>();
        for (OEM_Entropy_Finding__c f : [
            SELECT Id, Domain__c, MeasureKey__c, Severity__c, EntropyContribution__c, Delta__c, Summary__c, HelpUrl__c
            FROM OEM_Entropy_Finding__c
            WHERE Snapshot__c = :snapshotId AND MeasureKey__c = 'Acceleration'
            ORDER BY Delta__c DESC NULLS LAST
            LIMIT :limitSize
        ]) {
            FindingDTO d = new FindingDTO();
            d.id = f.Id;
            d.domain = f.Domain__c;
            d.measureKey = f.MeasureKey__c;
            d.severity = f.Severity__c;
            d.entropyContribution = (f.EntropyContribution__c == null ? null : Integer.valueOf(f.EntropyContribution__c));
            d.delta = (f.Delta__c == null ? null : Integer.valueOf(f.Delta__c));
            d.summary = f.Summary__c;
            d.helpUrl = f.HelpUrl__c;
            out.add(d);
        }
        return out;
    }

    @AuraEnabled(cacheable=true)
    public static List<FindingDTO> getMeasures(Id snapshotId, String domain, Integer limitSize) {
        if (limitSize == null || limitSize <= 0 || limitSize > 200) limitSize = 80;
        if (snapshotId == null) {
            List<OEM_Entropy_Snapshot__c> snaps = [SELECT Id FROM OEM_Entropy_Snapshot__c WHERE Status__c IN ('Completed','Partial') ORDER BY SnapshotDate__c DESC LIMIT 1];
            if (snaps.isEmpty()) return new List<FindingDTO>();
            snapshotId = snaps[0].Id;
        }

        String soql = 'SELECT Id, Domain__c, MeasureKey__c, Severity__c, EntropyContribution__c, Delta__c, Summary__c, HelpUrl__c ' +
                      'FROM OEM_Entropy_Finding__c WHERE Snapshot__c = :snapshotId ';
        if (!String.isBlank(domain)) soql += ' AND Domain__c = :domain';
        soql += ' ORDER BY EntropyContribution__c DESC NULLS LAST, Severity__c DESC LIMIT :limitSize';

        List<FindingDTO> out = new List<FindingDTO>();
        for (OEM_Entropy_Finding__c f : Database.query(soql)) {
            FindingDTO d = new FindingDTO();
            d.id = f.Id;
            d.domain = f.Domain__c;
            d.measureKey = f.MeasureKey__c;
            d.severity = f.Severity__c;
            d.entropyContribution = (f.EntropyContribution__c == null ? null : Integer.valueOf(f.EntropyContribution__c));
            d.delta = (f.Delta__c == null ? null : Integer.valueOf(f.Delta__c));
            d.summary = f.Summary__c;
            d.helpUrl = f.HelpUrl__c;
            out.add(d);
        }
        return out;
    }
}
