import React from 'react';
import { createRoot } from 'react-dom/client';
import ScoreChart from './components/ScoreChart';

document.addEventListener('DOMContentLoaded', () => {
  const scoreChart = document.getElementById('score-chart');
  if (scoreChart && scoreChart.dataset.scoresPath) {
    const root = createRoot(scoreChart);
    root.render(<ScoreChart jsonUrl={scoreChart.dataset.scoresPath}></ScoreChart>);
  }
});
