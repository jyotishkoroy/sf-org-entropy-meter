/**
 * Org Entropy Meter
 * Copyright 2026 Jyotishko Roy
 * Attribution: Jyotishko Roy (https://orcid.org/0009-0000-2837-4731)
 * Licensed under Apache-2.0 (see LICENSE).
 */

public without sharing class OEM_EntropyEngine {
    public class EngineResult {
        public List<OEM_MeasureResult> results = new List<OEM_MeasureResult>();
        public Map<String, Integer> domainScores = new Map<String, Integer>();
        public Integer entropyIndex;
        public Integer measuresAvailable;
        public Integer measuresTotal;
    }

    public static EngineResult run(OEM_DataProvider provider, List<IOEM_Measure> measures) {
        EngineResult er = new EngineResult();
        if (provider == null) provider = new OEM_OrgDataProvider();
        if (measures == null) measures = OEM_MeasureRegistry.defaultMeasures();

        Map<String, OEM_MeasureConfig> cfgByKey = loadMeasureConfigs(measures);
        Map<String, Decimal> domSum = new Map<String, Decimal>();
        Map<String, Decimal> domW = new Map<String, Decimal>();

        er.measuresTotal = measures.size();
        er.measuresAvailable = 0;

        for (IOEM_Measure m : measures) {
            OEM_MeasureConfig cfg = cfgByKey.get(m.key());
            if (cfg == null) cfg = m.defaultConfig();
            if (cfg != null && cfg.enabled == false) continue;

            try {
                OEM_MeasureResult r = m.evaluate(provider, cfg);
                if (r == null) continue;
                if (r.available == null) r.available = true;

                if (r.available == true && r.entropy == null && r.value != null) {
                    r.entropy = OEM_EntropyScoring.toEntropyScore(r.value, cfg.greenMax, cfg.yellowMax);
                }
                if (r.entropy != null && r.severity == null) r.severity = OEM_EntropyScoring.severityFromEntropy(r.entropy);
                er.results.add(r);

                if (r.available == true && r.entropy != null) {
                    er.measuresAvailable++;
                    Decimal w = (cfg != null && cfg.weight != null) ? cfg.weight : 1;
                    if (!domSum.containsKey(r.domain)) { domSum.put(r.domain, 0); domW.put(r.domain, 0); }
                    domSum.put(r.domain, domSum.get(r.domain) + (w * r.entropy));
                    domW.put(r.domain, domW.get(r.domain) + w);
                }
            } catch (Exception e) {
                er.results.add(OEM_MeasureResult.notAvailable(m.key(), m.domain(), OEM_Util.exceptionSummary(e)));
            }
        }

        for (String dom : domSum.keySet()) {
            Decimal wTotal = domW.get(dom);
            Integer score = (wTotal != null && wTotal > 0) ? (Integer)Math.round(domSum.get(dom) / wTotal) : 0;
            er.domainScores.put(dom, OEM_Util.clampInt(score, 0, 100));
        }

        Map<String, Decimal> domWeights = loadDomainWeights();
        Decimal idxSum = 0; Decimal idxW = 0;
        for (String dom : er.domainScores.keySet()) {
            Decimal w = domWeights.containsKey(dom) ? domWeights.get(dom) : 1;
            idxSum += w * er.domainScores.get(dom);
            idxW += w;
        }
        er.entropyIndex = (idxW > 0) ? (Integer)Math.round(idxSum / idxW) : 0;
        er.entropyIndex = OEM_Util.clampInt(er.entropyIndex, 0, 100);
        return er;
    }

    private static Map<String, OEM_MeasureConfig> loadMeasureConfigs(List<IOEM_Measure> measures) {
        Map<String, OEM_MeasureConfig> byKey = new Map<String, OEM_MeasureConfig>();
        for (IOEM_Measure m : measures) byKey.put(m.key(), m.defaultConfig());
        try {
            for (OEM_Measure_Config__mdt r : [
                SELECT Domain__c, MeasureKey__c, Weight__c, GreenMax__c, YellowMax__c, Units__c, Enabled__c
                FROM OEM_Measure_Config__mdt
                WHERE Enabled__c = true
            ]) {
                if (String.isBlank(r.MeasureKey__c)) continue;
                OEM_MeasureConfig c = new OEM_MeasureConfig();
                c.domain = r.Domain__c;
                c.key = r.MeasureKey__c;
                c.weight = r.Weight__c;
                c.greenMax = r.GreenMax__c;
                c.yellowMax = r.YellowMax__c;
                c.units = r.Units__c;
                c.enabled = r.Enabled__c;
                byKey.put(c.key, c);
            }
        } catch (Exception ex) { }
        return byKey;
    }

    private static Map<String, Decimal> loadDomainWeights() {
        Map<String, Decimal> w = new Map<String, Decimal>();
        try {
            for (OEM_Domain_Config__mdt r : [
                SELECT Domain__c, Weight__c, Enabled__c
                FROM OEM_Domain_Config__mdt
                WHERE Enabled__c = true
            ]) {
                if (!String.isBlank(r.Domain__c)) w.put(r.Domain__c, (r.Weight__c == null ? 1 : r.Weight__c));
            }
        } catch (Exception ex) { }
        return w;
    }
}
