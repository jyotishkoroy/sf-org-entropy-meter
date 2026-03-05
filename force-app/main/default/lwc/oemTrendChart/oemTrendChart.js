import { LightningElement, api } from 'lwc';
export default class OemTrendChart extends LightningElement {
  @api series = [];
  get hasData() { return Array.isArray(this.series) && this.series.length >= 2; }
  get normalized() {
    const min = 0, max = 100, span = 100;
    const w = 600, h = 200, pad = 16;
    return (this.series || []).map((p, i) => {
      const x = pad + (i * (w - 2 * pad)) / Math.max(1, (this.series.length - 1));
      const y = pad + (h - 2 * pad) * (1 - ((Number(p.y || 0) - min) / span));
      return { key: i, x, y };
    });
  }
  get points() { return this.normalized; }
  get linePath() {
    const pts = this.normalized; if (!pts.length) return '';
    let d = `M ${pts[0].x} ${pts[0].y}`;
    for (let i=1;i<pts.length;i++) d += ` L ${pts[i].x} ${pts[i].y}`;
    return d;
  }
  get areaPath() {
    const pts = this.normalized; if (!pts.length) return '';
    const h = 200, pad = 16;
    let d = this.linePath;
    d += ` L ${pts[pts.length-1].x} ${h-pad} L ${pts[0].x} ${h-pad} Z`;
    return d;
  }
}
