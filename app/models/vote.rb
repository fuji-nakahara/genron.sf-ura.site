# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :work, counter_cache: true

  validate :up_to_three_votes_per_kadai

  private

  def up_to_three_votes_per_kadai
    vote_count = Vote
                   .joins(work: :kadai)
                   .merge(Work.where(type: work.type))
                   .merge(Kadai.where(id: work.kadai_id))
                   .where(user_id: user.id)
                   .count

    errors.add(:base, '1つの課題につき3作品までしか投票できません') if vote_count >= 3
  end
end
