/**
 * Org Entropy Meter
 * Copyright 2026 Jyotishko Roy
 * Attribution: Jyotishko Roy (https://orcid.org/0009-0000-2837-4731)
 * Licensed under Apache-2.0 (see LICENSE).
 */

public without sharing class OEM_SnapshotService {
    public static final String APP_VERSION = '0.1.0';
    public static final Integer ACCELERATION_THRESHOLD = 10;

    public static Id runSnapshot(String baselineLabel) {
        Long startMs = DateTime.now().getTime();

        OEM_Entropy_Snapshot__c snap = new OEM_Entropy_Snapshot__c();
        snap.Name = 'Snapshot ' + DateTime.now().format('yyyy-MM-dd HH:mm');
        snap.SnapshotDate__c = System.now();
        snap.Status__c = 'Running';
        snap.OrgId__c = UserInfo.getOrganizationId();
        snap.IsSandbox__c = UserInfo.isSandbox();
        snap.OrgName__c = safeOrgName();
        snap.AppVersion__c = APP_VERSION;
        insert snap;

        try {
            OEM_EntropyEngine.EngineResult er = OEM_EntropyEngine.run(new OEM_OrgDataProvider(), OEM_MeasureRegistry.defaultMeasures());

            List<OEM_Entropy_Finding__c> findings = new List<OEM_Entropy_Finding__c>();
            for (OEM_MeasureResult r : er.results) {
                OEM_Entropy_Finding__c f = new OEM_Entropy_Finding__c();
                f.Name = r.key + ' - ' + snap.Name;
                f.Snapshot__c = snap.Id;
                f.Domain__c = r.domain;
                f.MeasureKey__c = r.key;
                f.Severity__c = (r.severity == null ? 'Info' : r.severity);
                f.EntropyContribution__c = (r.entropy == null ? null : r.entropy);
                f.Summary__c = OEM_Util.safeString(r.summary, 255);
                f.Details__c = r.details;
                f.SuggestedAction__c = r.suggestedAction;
                f.HelpUrl__c = r.helpUrl;
                f.IsAvailable__c = (r.available == null ? true : r.available);
                findings.add(f);
            }
            if (!findings.isEmpty()) insert findings;

            snap.EntropyIndex__c = er.entropyIndex;
            snap.ChangeVelocity__c = er.domainScores.get('Change Velocity');
            snap.AutomationSprawl__c = er.domainScores.get('Automation Sprawl');
            snap.PermissionSprawl__c = er.domainScores.get('Permission Sprawl');
            snap.Duplication__c = er.domainScores.get('Duplication');
            snap.Hotspots__c = er.domainScores.get('Hotspots');
            snap.MeasuresAvailable__c = er.measuresAvailable;
            snap.MeasuresTotal__c = er.measuresTotal;
            snap.Status__c = (er.measuresAvailable == er.measuresTotal) ? 'Completed' : 'Partial';

            writeAccelerationAlerts(snap);
        } catch (Exception e) {
            snap.Status__c = 'Failed';
            OEM_Entropy_Finding__c f = new OEM_Entropy_Finding__c();
            f.Name = 'Snapshot Failure - ' + snap.Name;
            f.Snapshot__c = snap.Id;
            f.Domain__c = 'Duplication';
            f.MeasureKey__c = 'SnapshotFailure';
            f.Severity__c = 'Critical';
            f.Summary__c = 'Snapshot failed';
            f.Details__c = 'Exception: ' + OEM_Util.exceptionSummary(e);
            f.SuggestedAction__c = 'Review logs and permissions for the running user.';
            f.IsAvailable__c = true;
            insert f;
        } finally {
            snap.DurationMs__c = DateTime.now().getTime() - startMs;
            update snap;
        }
        return snap.Id;
    }

    private static void writeAccelerationAlerts(OEM_Entropy_Snapshot__c latest) {
        if (latest == null || latest.Id == null) return;
        List<OEM_Entropy_Snapshot__c> prev = [
            SELECT Id, EntropyIndex__c, ChangeVelocity__c, AutomationSprawl__c, PermissionSprawl__c, Duplication__c, Hotspots__c
            FROM OEM_Entropy_Snapshot__c
            WHERE Status__c IN ('Completed','Partial') AND Id != :latest.Id
            ORDER BY SnapshotDate__c DESC
            LIMIT 1
        ];
        if (prev.isEmpty()) return;
        OEM_Entropy_Snapshot__c p = prev[0];

        List<OEM_Entropy_Finding__c> alerts = new List<OEM_Entropy_Finding__c>();
        alerts.addAll(checkDomain(latest.Id, 'Change Velocity', latest.ChangeVelocity__c, p.ChangeVelocity__c));
        alerts.addAll(checkDomain(latest.Id, 'Automation Sprawl', latest.AutomationSprawl__c, p.AutomationSprawl__c));
        alerts.addAll(checkDomain(latest.Id, 'Permission Sprawl', latest.PermissionSprawl__c, p.PermissionSprawl__c));
        alerts.addAll(checkDomain(latest.Id, 'Duplication', latest.Duplication__c, p.Duplication__c));
        alerts.addAll(checkDomain(latest.Id, 'Hotspots', latest.Hotspots__c, p.Hotspots__c));

        if (!alerts.isEmpty()) insert alerts;
    }

    private static List<OEM_Entropy_Finding__c> checkDomain(Id snapId, String domain, Decimal cur, Decimal old) {
        List<OEM_Entropy_Finding__c> out = new List<OEM_Entropy_Finding__c>();
        if (cur == null || old == null) return out;
        Integer d = Integer.valueOf(cur) - Integer.valueOf(old);
        if (d >= ACCELERATION_THRESHOLD) {
            OEM_Entropy_Finding__c f = new OEM_Entropy_Finding__c();
            f.Name = 'Acceleration - ' + domain;
            f.Snapshot__c = snapId;
            f.Domain__c = domain;
            f.MeasureKey__c = 'Acceleration';
            f.Severity__c = 'High';
            f.Delta__c = d;
            f.Summary__c = domain + ' entropy accelerated (+' + d + ')';
            f.Details__c = 'Domain increased sharply vs previous snapshot.';
            f.SuggestedAction__c = 'Review recent changes in this domain and apply cleanup.';
            f.IsAvailable__c = true;
            out.add(f);
        }
        return out;
    }

    private static String safeOrgName() {
        try { return [SELECT Name FROM Organization LIMIT 1].Name; }
        catch (Exception e) { return null; }
    }
}
