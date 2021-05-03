import * as palette from "google-palette";
import { FC, useEffect, useState } from "react";
import { Spinner } from "react-bootstrap";
import ChartComponent from "react-chartjs-2";

type Props = {
  url: string;
};

type ScoreTable = {
  student: string;
  scores: number[];
}[];

async function getScoreTable(url: string): Promise<ScoreTable> {
  const response = await fetch(url);
  if (response.ok) {
    return await response.json();
  } else {
    throw new Error(
      `Failed to fetch scoreTable from ${url} (${response.status})`
    );
  }
}

const ScoreChart: FC<Props> = ({ url }) => {
  const [scoreTable, setScoreTable] = useState<ScoreTable | null>(null);

  useEffect(() => {
    (async () => {
      const scoreTable = await getScoreTable(url);
      setScoreTable(scoreTable);
    })();
  }, [url]);

  if (scoreTable === null) {
    return (
      <div className="d-flex justify-content-center">
        <Spinner animation="border" role="status">
          <span className="visually-hidden">Loading...</span>
        </Spinner>
      </div>
    );
  }

  const labelLength = Math.max(...scoreTable.map((row) => row.scores.length));
  const labels = [...Array(labelLength).keys()].map((i) => `第${i + 1}回`);

  const colors = palette("tol-rainbow", scoreTable.length);
  const datasets = scoreTable.map((row, i) => {
    let sum = 0;
    const accumulatedScores = row.scores.map((score) => {
      sum += score;
      return sum;
    });

    return {
      label: row.student,
      data: accumulatedScores,
      backgroundColor: `#${colors[i]}`,
      borderColor: `#${colors[i]}`,
      pointRadius: 8,
      pointHoverRadius: 12,
      tension: 0.4,
    };
  });

  return (
    <ChartComponent type="line" data={{ labels: labels, datasets: datasets }} />
  );
};

export default ScoreChart;
