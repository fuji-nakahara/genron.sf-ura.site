# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'StudentsController:' do
  describe 'GET /:term_year/students' do
    let(:term) { create(:term) }

    before do
      kadais = create_pair(:kadai, term:)
      create_list(:kougai, 3, kadai: kadais.sample)
      create_list(:jissaku, 3, kadai: kadais.sample)
    end

    it 'responds OK' do
      get term_students_path(term)

      expect(response).to have_http_status :ok
    end

    context 'with .json format' do
      it 'responds OK' do
        get term_students_path(term, format: :json)

        expect(response).to have_http_status :ok
      end
    end
  end

  describe 'GET /students/:id' do
    let(:student) { create(:student) }

    it 'responds OK' do
      get student_path(student)

      expect(response).to have_http_status :ok
    end

    context 'with .json format' do
      it 'responds OK' do
        get student_path(student, format: :json)

        expect(response).to have_http_status :ok
      end
    end
  end
end
