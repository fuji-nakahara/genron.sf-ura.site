# frozen_string_literal: true

class KadaisController < ApplicationController
  def show
    @kadai = Kadai.find(params[:id])
  end

  def find
    @kadai = Kadai.find_by!(year: params[:year], number: params[:number])
    redirect_to @kadai, status: :moved_permanently
  end
end
