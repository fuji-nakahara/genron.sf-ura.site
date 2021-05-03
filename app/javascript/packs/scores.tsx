import * as ReactDOM from "react-dom";
import ScoreChart from "../components/ScoreChart";

document.addEventListener("DOMContentLoaded", () => {
  const scoreChart = document.getElementById("score-chart");
  if (scoreChart) {
    ReactDOM.render(<ScoreChart></ScoreChart>, scoreChart);
  }
});
