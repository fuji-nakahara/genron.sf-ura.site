import { Controller } from 'stimulus'
import Chart from 'chart.js'
import * as palette from 'google-palette';

export default class extends Controller {
  connect () {
    const canvas = this.element

    const labels = JSON.parse(this.data.get('labels'))
    const rawDatasets = JSON.parse(this.data.get('datasets'))

    const colors = palette('tol-rainbow', rawDatasets.length).map(hex => '#' + hex);
    const datasets = rawDatasets.map((dataset, i) => {
      return {
        label: dataset.label,
        data: dataset.data,
        backgroundColor: colors[i],
        borderColor: colors[i],
        pointRadius: 8,
        pointHoverRadius: 12,
        fill: false
      }
    })

    new Chart(canvas, {
      type: 'line',
      data: {
        labels: labels,
        datasets: datasets
      },
      options: {
        aspectRatio: 2,
        tooltips: {
          mode: 'point',
          itemSort (a, b) {
            return b.yLabel - a.yLabel
          }
        },
        hover: {
          mode: 'point'
        }
      }
    })
  }
}
