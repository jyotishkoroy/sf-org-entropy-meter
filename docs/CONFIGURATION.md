# Configuration

Entropy scoring thresholds and weights are configurable via Custom Metadata Types:

- `OEM_Measure_Config__mdt`
  - `MeasureKey__c` (unique)
  - `Domain__c`
  - `Weight__c`
  - `GreenMax__c`, `YellowMax__c` (thresholds)
  - `Enabled__c`

- `OEM_Domain_Config__mdt`
  - `Domain__c` (unique)
  - `Weight__c`
  - `Enabled__c`

Notes:
- Disable measures that are noisy for your org by setting `Enabled__c = false`.
- Use lower thresholds for smaller orgs to make the meter more sensitive.
