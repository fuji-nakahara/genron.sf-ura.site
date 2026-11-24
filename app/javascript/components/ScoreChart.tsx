import {
  CategoryScale,
  Chart as ChartJS,
  Legend,
  LinearScale,
  LineElement,
  PointElement,
  Tooltip,
} from "chart.js";
// @ts-expect-error google-palette has no type definitions
import palette from "google-palette";
import React, { useEffect, useState } from "react";
import { Line } from "react-chartjs-2";
import { ScoreTable } from "../types";
import LoadingSpinner from "./LoadingSpinner";

ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Tooltip,
  Legend,
);

type Props = {
  jsonUrl: string;
};

const ScoreChart: React.FC<Props> = ({ jsonUrl }: Props) => {
  const [scoreTable, setScoreTable] = useState<
    ScoreTable | "loading" | "unavailable"
  >("loading");

  useEffect(() => {
    const controller = new AbortController();
    setScoreTable("loading");

    (async () => {
      try {
        const response = await fetch(jsonUrl, { signal: controller.signal });
        const scores = response.ok ? await response.json() : "unavailable";

        if (!controller.signal.aborted) {
          setScoreTable(scores);
        }
      } catch {
        if (!controller.signal.aborted) {
          setScoreTable("unavailable");
        }
      }
    })();

    return () => controller.abort();
  }, [jsonUrl]);

  if (scoreTable === "loading") {
    return <LoadingSpinner />;
  }

  if (scoreTable === "unavailable") {
    return <p role="status">得点一覧を取得できません。</p>;
  }

  if (scoreTable.length === 0) {
    return <p role="status">表示できる得点がありません。</p>;
  }

  const colors = palette("tol-rainbow", scoreTable.length);
  const data = {
    labels: [
      ...Array(Math.max(...scoreTable.map((row) => row.scores.length))).keys(),
    ].map((i) => `第${i + 1}回`),
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

  return <Line data={data} />;
};

export default ScoreChart;
