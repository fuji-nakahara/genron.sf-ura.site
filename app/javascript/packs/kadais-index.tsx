import React from 'react';
import ReactDOM from 'react-dom';
import ScoreChart from 'ScoreChart';

document.addEventListener('DOMContentLoaded', () => {
  const scoreChart = document.getElementById('score-chart');
  if (scoreChart && scoreChart.dataset.scoresPath) {
    ReactDOM.render(<ScoreChart jsonUrl={scoreChart.dataset.scoresPath}></ScoreChart>, scoreChart);
  }
});
