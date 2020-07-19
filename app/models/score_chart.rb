# frozen_string_literal: true

class ScoreChart
  attr_reader :score_table

  def initialize(score_table)
    @score_table = score_table
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
end
