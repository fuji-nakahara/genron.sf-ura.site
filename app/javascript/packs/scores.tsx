import * as ReactDOM from "react-dom";
import ScoreChart from "../components/ScoreChart";

document.addEventListener("DOMContentLoaded", () => {
  const scoreChart = document.getElementById("score-chart");
  if (scoreChart && scoreChart.dataset.url) {
    ReactDOM.render(
      <ScoreChart url={scoreChart.dataset.url}></ScoreChart>,
      scoreChart
    );
  }
});
