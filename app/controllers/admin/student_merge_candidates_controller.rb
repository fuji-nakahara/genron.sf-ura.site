# frozen_string_literal: true

module Admin
  class StudentMergeCandidatesController < ApplicationController
    include AdminRequired

    def destroy
      candidate = StudentMergeCandidate.find(params[:id])
      candidate.destroy!
      redirect_to admin_root_path, notice: '削除しました'
    end
  end
end
