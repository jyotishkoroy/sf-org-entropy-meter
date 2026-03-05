/**
 * Org Entropy Meter
 * Copyright 2026 Jyotishko Roy
 * Attribution: Jyotishko Roy (https://orcid.org/0009-0000-2837-4731)
 * Licensed under Apache-2.0 (see LICENSE).
 */

public class OEM_Util {
    public static Integer clampInt(Integer value, Integer minVal, Integer maxVal) {
        if (value == null) return minVal;
        return Math.max(minVal, Math.min(maxVal, value));
    }
    public static String safeString(String s, Integer maxLen) {
        if (s == null) return null;
        if (maxLen == null || s.length() <= maxLen) return s;
        return s.substring(0, maxLen);
    }
    public static String exceptionSummary(Exception e) {
        if (e == null) return null;
        String msg = e.getMessage();
        if (String.isBlank(msg)) msg = e.getTypeName();
        return safeString(msg, 240);
    }
}
