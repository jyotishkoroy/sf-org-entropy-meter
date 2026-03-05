# Org Entropy Meter

Salesforce-native **Maintainability Drift Index** that quantifies “org entropy” over time.

- Entropy Index (0–100): higher = more disorder
- Domains: Change Velocity, Automation Sprawl, Permission Sprawl, Duplication, Hotspots
- Trend lines: 7/30/90 days
- Acceleration alerts (spikes vs previous snapshot)

**Author:** Jyotishko Roy (https://orcid.org/0009-0000-2837-4731)

## Install (SFDX)
```bash
sf org login web -a target
sf project deploy start -o target -p force-app
sf permset assign -o target -n OrgEntropyMeter_Admin
```
