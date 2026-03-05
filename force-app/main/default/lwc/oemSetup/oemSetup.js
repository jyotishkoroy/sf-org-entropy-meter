import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import runSnapshotNow from '@salesforce/apex/OEM_SetupController.runSnapshotNow';
import scheduleDaily from '@salesforce/apex/OEM_SetupController.scheduleDaily';
import unscheduleApex from '@salesforce/apex/OEM_SetupController.unschedule';
import getScheduleStatus from '@salesforce/apex/OEM_SetupController.getScheduleStatus';

export default class OemSetup extends LightningElement {
  @track loading = false;
  @track baselineLabel = '';
  @track hour = 2;
  @track minute = 25;
  @track status;

  connectedCallback() { this.refreshStatus(); }

  onBaselineChange(e) { this.baselineLabel = e.detail.value; }
  onHour(e) { this.hour = Number(e.detail.value); }
  onMinute(e) { this.minute = Number(e.detail.value); }

  async runNow() {
    this.loading = true;
    try {
      await runSnapshotNow({ baselineLabel: this.baselineLabel });
      this.toast('Queued', 'Snapshot queued. Refresh the Dashboard in a minute.', 'success');
    } catch (e) {
      this.toast('Error', this.normalizeError(e), 'error');
    } finally {
      this.loading = false;
    }
  }

  async schedule() {
    this.loading = true;
    try {
      const cron = await scheduleDaily({ hourLocal: this.hour, minuteLocal: this.minute });
      this.toast('Scheduled', `Daily snapshot scheduled. Cron: ${cron}`, 'success');
      await this.refreshStatus();
    } catch (e) {
      this.toast('Error', this.normalizeError(e), 'error');
    } finally {
      this.loading = false;
    }
  }

  async unschedule() {
    this.loading = true;
    try {
      await unscheduleApex();
      this.toast('Unschedule', 'Daily snapshot unscheduled.', 'success');
      await this.refreshStatus();
    } catch (e) {
      this.toast('Error', this.normalizeError(e), 'error');
    } finally {
      this.loading = false;
    }
  }

  async refreshStatus() {
    try { this.status = await getScheduleStatus(); } catch (e) { /* ignore */ }
  }

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
