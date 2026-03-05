# Contributing
Contributions are welcome. By contributing, you agree contributions are licensed under Apache-2.0.

## Quick start
```bash
sf org create scratch -f config/project-scratch-def.json -a oem-dev -d -y 7
sf project deploy start -p force-app
sf permset assign -n OrgEntropyMeter_Admin
sf org open -p lightning/n/Org_Entropy_Meter
```
