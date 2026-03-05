# Troubleshooting

## Dashboard shows “No snapshots yet”
Run a snapshot from the Setup tab, or execute:
```bash
sf apex run -o target -f scripts/apex/run-snapshot-now.apex
```

## Snapshot is always “Partial”
Some orgs do not expose certain system objects/views to all admins (edition/permissions differ).
This app treats those measures as best-effort and continues.

To see the reason:
- Open the latest **Entropy Findings**
- Filter by measures that show “Not available”
- Review Details + Suggested Action

## Apex test failures
Ensure you run tests in an org where the custom objects exist (after deployment):
```bash
sf apex test run -o target -r human -c
```
