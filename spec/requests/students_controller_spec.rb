# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'StudentsController:', type: :request do
  describe 'GET /students/:id' do
    let(:student) { create(:student) }

    it 'responds OK' do
      get student_path(student)

      expect(response).to have_http_status :ok
    end
  end
end
