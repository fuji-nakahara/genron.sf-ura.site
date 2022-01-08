# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Students::JissakusController:', type: :request do
  describe 'GET /students/:student_id/jissakus' do
    let(:student) { create(:student) }

    before do
      create_list(:jissaku, 3, student:)
    end

    it 'responds OK' do
      get student_jissakus_path(student)

      expect(response).to have_http_status :ok
    end
  end
end
