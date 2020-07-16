# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :work, counter_cache: true

  validates :user_id, uniqueness: { scope: :work_id, message: '1つの作品に2票入れることはできません' }
  validate :up_to_three_votes_per_kadai
  validate :unable_to_vote_for_own_work

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

  def unable_to_vote_for_own_work
    errors.add(:base, '自分の作品には投票できません') if user.student_id == work.student_id
  end
end
