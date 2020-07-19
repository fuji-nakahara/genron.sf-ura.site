# frozen_string_literal: true

class ScoreChart
  attr_reader :year

  def initialize(year)
    @year = year
  end

  def labels
    (1..score_table.values.map(&:size).max).to_a.map { |i| "第#{i}回" }
  end

  def datasets
    score_table.map do |name, scores|
      sum = 0
      accumulated_scores = scores.map { |score| sum += score }
      { label: name, data: accumulated_scores }
    end
  end

  def score_table
    @score_table ||= Rails.cache.fetch("score_chart/#{year}/score_table/", expires_in: 1.day) do
      GenronSF::ScoreTable.get(year: year).to_h
    end
  end
end
