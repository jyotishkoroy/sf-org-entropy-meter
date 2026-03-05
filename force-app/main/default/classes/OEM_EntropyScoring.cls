/**
 * Org Entropy Meter
 * Copyright 2026 Jyotishko Roy
 * Attribution: Jyotishko Roy (https://orcid.org/0009-0000-2837-4731)
 * Licensed under Apache-2.0 (see LICENSE).
 */

public class OEM_EntropyScoring {
    public static Integer toEntropyScore(Decimal value, Decimal greenMax, Decimal yellowMax) {
        if (value == null) return 0;
        if (greenMax == null) greenMax = 0;
        if (yellowMax == null) yellowMax = greenMax;

        if (value <= greenMax) {
            if (greenMax <= 0) return 10;
            Decimal pct = value / greenMax;
            return OEM_Util.clampInt((Integer)Math.round(5 + (15 * pct)), 0, 20);
        }
        if (value <= yellowMax) {
            Decimal span = (yellowMax - greenMax);
            if (span <= 0) return 45;
            Decimal pct2 = (value - greenMax) / span;
            return OEM_Util.clampInt((Integer)Math.round(20 + (50 * pct2)), 20, 70);
        }
        Decimal over = (yellowMax <= 0) ? value : (value - yellowMax);
        Decimal penalty = Math.min(30, over * 2);
        return OEM_Util.clampInt((Integer)Math.round(70 + penalty), 70, 100);
    }
    public static String severityFromEntropy(Integer entropy) {
        if (entropy == null) return 'Info';
        if (entropy >= 90) return 'Critical';
        if (entropy >= 75) return 'High';
        if (entropy >= 55) return 'Medium';
        if (entropy >= 30) return 'Low';
        return 'Info';
    }
}
