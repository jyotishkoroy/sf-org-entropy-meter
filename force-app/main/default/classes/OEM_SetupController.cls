/**
 * Org Entropy Meter
 * Copyright 2026 Jyotishko Roy
 * Attribution: Jyotishko Roy (https://orcid.org/0009-0000-2837-4731)
 * Licensed under Apache-2.0 (see LICENSE).
 */

public with sharing class OEM_SetupController {
    public class ScheduleStatusDTO {
        @AuraEnabled public Boolean scheduled;
        @AuraEnabled public String cron;
        @AuraEnabled public String nextFireTime;
    }

    @AuraEnabled
    public static String runSnapshotNow(String baselineLabel) {
        System.enqueueJob(new OEM_SnapshotRunner(baselineLabel));
        return 'queued';
    }

    @AuraEnabled
    public static String scheduleDaily(Integer hourLocal, Integer minuteLocal) {
        return OEM_SnapshotScheduler.scheduleDaily(hourLocal, minuteLocal);
    }

    @AuraEnabled
    public static void unschedule() {
        OEM_SnapshotScheduler.abortExisting();
    }

    @AuraEnabled(cacheable=true)
    public static ScheduleStatusDTO getScheduleStatus() {
        ScheduleStatusDTO dto = new ScheduleStatusDTO();
        dto.scheduled = false;

        List<CronTrigger> cts = [
            SELECT CronExpression, NextFireTime, State
            FROM CronTrigger
            WHERE CronJobDetail.Name = :OEM_SnapshotScheduler.JOB_NAME
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];
        if (!cts.isEmpty() && cts[0].State == 'WAITING') {
            dto.scheduled = true;
            dto.cron = cts[0].CronExpression;
            dto.nextFireTime = String.valueOf(cts[0].NextFireTime);
        }
        return dto;
    }
}
