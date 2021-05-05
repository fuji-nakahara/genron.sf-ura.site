# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Students::KougaisController:', type: :request do
  describe 'GET /students/:student_id/kougais' do
    let(:student) { create(:student) }

    before do
      create_list(:kougai, 3, student: student)
    end

    it 'responds OK' do
      get student_kougais_path(student)

      expect(response).to have_http_status :ok
    end
  end
end
