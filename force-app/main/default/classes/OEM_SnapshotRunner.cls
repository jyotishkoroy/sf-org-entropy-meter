/**
 * Org Entropy Meter
 * Copyright 2026 Jyotishko Roy
 * Attribution: Jyotishko Roy (https://orcid.org/0009-0000-2837-4731)
 * Licensed under Apache-2.0 (see LICENSE).
 */

public without sharing class OEM_SnapshotRunner implements Queueable {
    private String baselineLabel;
    public OEM_SnapshotRunner(String baselineLabel) { this.baselineLabel = baselineLabel; }
    public void execute(QueueableContext context) { OEM_SnapshotService.runSnapshot(baselineLabel); }
}
