# Setup Guide (Org Entropy Meter)

This guide is written so an admin can deploy and run the app in **any Salesforce org** (sandbox or production)
with minimal assumptions.

## Prerequisites
- Salesforce CLI (sf)
- A Salesforce org where you have permissions to deploy metadata and run Apex

## 1) Authenticate
```bash
sf org login web -a target
```

## 2) Deploy metadata
From the repo root:
```bash
sf project deploy start -o target -p force-app
```

## 3) Assign permissions
Admins (recommended):
```bash
sf permset assign -o target -n OrgEntropyMeter_Admin
```

Read-only users:
```bash
sf permset assign -o target -n OrgEntropyMeter_User
```

## 4) Open the app
- App Launcher → **Org Entropy Meter**
- Tabs: Dashboard, Setup, Entropy Snapshots, Entropy Findings

## 5) Run your first snapshot
- Go to **Setup** tab → *Run snapshot now*
- Wait ~30–90 seconds (depending on org size)
- Refresh the **Dashboard** tab

## 6) Schedule daily snapshots (optional)
- Setup tab → choose hour/minute → *Schedule daily*
- Scheduling runs under the scheduling user (standard Salesforce behavior)

## What to expect
- On the first run, trends/acceleration will be empty (requires 2+ snapshots).
- Some measures are “best-effort” and may show **Not available** if your org or profile does not allow access
  to particular system views. The snapshot will still complete as **Partial**.

## Uninstall
Use standard metadata uninstall tooling for your org workflow. Since this is a source-deployed app,
the safest approach is to remove the metadata components using a package.xml delete deployment or
your preferred DevOps process.
