/**
 * Org Entropy Meter
 * Copyright 2026 Jyotishko Roy
 * Attribution: Jyotishko Roy (https://orcid.org/0009-0000-2837-4731)
 * Licensed under Apache-2.0 (see LICENSE).
 */

public without sharing class OEM_SnapshotScheduler implements Schedulable {
    public static final String JOB_NAME = 'OrgEntropyMeter_DailySnapshot';
    public void execute(SchedulableContext sc) { System.enqueueJob(new OEM_SnapshotRunner(null)); }

    public static String scheduleDaily(Integer hourLocal, Integer minuteLocal) {
        abortExisting();
        if (hourLocal == null) hourLocal = 2;
        if (minuteLocal == null) minuteLocal = 25;
        String cron = String.format('0 {0} {1} * * ?', new List<String>{ String.valueOf(minuteLocal), String.valueOf(hourLocal) });
        System.schedule(JOB_NAME, cron, new OEM_SnapshotScheduler());
        return cron;
    }

    public static void abortExisting() {
        for (CronTrigger ct : [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name = :JOB_NAME]) {
            try { System.abortJob(ct.Id); } catch (Exception e) {}
        }
    }
}
