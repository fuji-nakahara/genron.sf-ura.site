import { Controller } from 'stimulus'
import Chart from 'chart.js'
import * as palette from 'google-palette'

export default class extends Controller {
  async connect () {
    const scoreTable = await this.getScoreTable()

    scoreTable.forEach(row => {
      let sum = 0
      row.accumulatedScores = row.scores.map(score => {
        sum += score
        return sum
      })
    })

    const colors = palette('tol-rainbow', scoreTable.length).map(hex => '#' + hex)
    const datasets = scoreTable.map((row, i) => {
      return {
        label: row.student,
        data: row.accumulatedScores,
        backgroundColor: colors[i],
        borderColor: colors[i],
        pointRadius: 8,
        pointHoverRadius: 12,
        fill: false
      }
    })

    const labelLength = scoreTable.map(row => row.scores.length).reduce((maxScore, score) => Math.max(maxScore, score))
    const labels = Array.from(Array(labelLength).keys()).map(i => `第${i + 1}回`)

    new Chart(this.element, {
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

  async getScoreTable () {
    const response = await fetch(this.data.get('endpoint'))
    if (response.ok) {
      return await response.json()
    } else {
      throw new Error(`${response.status}: ${response.statusText}`)
    }
  }
}
