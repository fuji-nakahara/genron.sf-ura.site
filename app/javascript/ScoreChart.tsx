// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import * as palette from 'google-palette';
import React, { useEffect, useState } from 'react';
import ChartComponent from 'react-chartjs-2';
import LoadingSpinner from 'LoadingSpinner';
import { ScoreTable } from 'types';

type Props = {
  jsonUrl: string;
};

const ScoreChart: React.FC<Props> = ({ jsonUrl }: Props) => {
  const [scoreTable, setScoreTable] = useState<ScoreTable | null>(null);

  useEffect(() => {
    (async () => {
      const response = await fetch(jsonUrl);
      if (response.ok) {
        const scoreTable = await response.json();
        setScoreTable(scoreTable);
      } else {
        throw new Error(`Failed GET ${jsonUrl} ${response.status} (${response.statusText})`);
      }
    })();
  }, [jsonUrl]);

  if (scoreTable === null) {
    return <LoadingSpinner />;
  }

  const colors = palette('tol-rainbow', scoreTable.length);
  const data = {
    labels: [...Array(Math.max(...scoreTable.map((row) => row.scores.length))).keys()].map((i) => `第${i + 1}回`),
    datasets: scoreTable.map((row, i) => {
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
    }),
  };

  return <ChartComponent type="line" data={data} />;
};

export default ScoreChart;
