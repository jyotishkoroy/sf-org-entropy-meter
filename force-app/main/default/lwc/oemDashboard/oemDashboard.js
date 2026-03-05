import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getLatestSnapshot from '@salesforce/apex/OEM_DashboardController.getLatestSnapshot';
import getTrend from '@salesforce/apex/OEM_DashboardController.getTrend';
import getAlerts from '@salesforce/apex/OEM_DashboardController.getAlerts';
import getMeasures from '@salesforce/apex/OEM_DashboardController.getMeasures';

export default class OemDashboard extends LightningElement {
  @track snap;
  @track trend = [];
  @track alerts = [];
  @track measures = [];
  @track loading = false;

  windowDays = '30';
  filterDomain = '';

  windowOptions = [
    { label: '7 days', value: '7' },
    { label: '30 days', value: '30' },
    { label: '90 days', value: '90' }
  ];

  domainOptions = [
    { label: 'All', value: '' },
    { label: 'Change Velocity', value: 'Change Velocity' },
    { label: 'Automation Sprawl', value: 'Automation Sprawl' },
    { label: 'Permission Sprawl', value: 'Permission Sprawl' },
    { label: 'Duplication', value: 'Duplication' },
    { label: 'Hotspots', value: 'Hotspots' }
  ];

  alertColumns = [
    { label: 'Domain', fieldName: 'domain', initialWidth: 180 },
    { label: 'Δ', fieldName: 'delta', type: 'number', initialWidth: 70 },
    { label: 'Summary', fieldName: 'summary', wrapText: true }
  ];

  measureColumns = [
    { label: 'Severity', fieldName: 'severity', initialWidth: 90 },
    { label: 'Domain', fieldName: 'domain', initialWidth: 170 },
    { label: 'Measure', fieldName: 'measureKey', initialWidth: 220 },
    { label: 'Entropy', fieldName: 'entropyContribution', type: 'number', initialWidth: 90 },
    { label: 'Summary', fieldName: 'summary', wrapText: true },
    { label: 'Help', fieldName: 'helpUrl', type: 'url', typeAttributes: { label: { fieldName: 'helpUrl' }, target: '_blank' } }
  ];

  connectedCallback() { this.refresh(); }

  get snapDateText() {
    return this.snap?.snapshotDate ? new Date(this.snap.snapshotDate).toLocaleString() : '';
  }

  async refresh() {
    this.loading = true;
    try {
      this.snap = await getLatestSnapshot();
      const days = Number(this.windowDays || 30);
      this.trend = await getTrend({ days });
      this.alerts = await getAlerts({ snapshotId: this.snap?.id, limitSize: 30 });
      await this.loadMeasures();
    } catch (e) {
      this.toast('Error', this.normalizeError(e), 'error');
    } finally {
      this.loading = false;
    }
  }

  async loadMeasures() {
    try {
      this.measures = await getMeasures({ snapshotId: this.snap?.id, domain: this.filterDomain, limitSize: 80 });
    } catch (e) {
      this.toast('Error', this.normalizeError(e), 'error');
    }
  }

  handleWindowChange(evt) { this.windowDays = evt.detail.value; this.refresh(); }
  handleDomainChange(evt) { this.filterDomain = evt.detail.value; }

  toast(title, message, variant) {
    this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
  }

  normalizeError(e) {
    if (!e) return 'Unknown error';
    if (Array.isArray(e.body)) return e.body.map(x => x.message).join(', ');
    if (typeof e.body?.message === 'string') return e.body.message;
    return e.message || 'Unknown error';
  }
}
