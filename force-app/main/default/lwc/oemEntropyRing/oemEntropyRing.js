import { LightningElement, api } from 'lwc';
export default class OemEntropyRing extends LightningElement {
  @api score = 0;
  @api label = 'Entropy';
  @api hint = 'Higher is worse';
  get strokeStyle() {
    const s = Number(this.score || 0);
    const r = 48;
    const c = 2 * Math.PI * r;
    const pct = Math.max(0, Math.min(100, s)) / 100;
    const dash = (pct * c).toFixed(2);
    return `stroke-dasharray:${dash} ${c.toFixed(2)};`;
  }
}
