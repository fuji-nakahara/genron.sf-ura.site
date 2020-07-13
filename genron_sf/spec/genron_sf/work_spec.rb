# frozen_string_literal: true

RSpec.describe GenronSF::Work do
  describe '.get' do
    subject(:work) { described_class.get(year: 2018, student_id: 'fujinakahara', id: 2683) }

    it 'fetches the work page, parses its HTML and returns Work instance' do
      expect(work.year).to eq 2018
      expect(work.id).to eq 2683
      expect(work.subject.number).to eq 6
      expect(work.student.id).to eq 'fujinakahara'
      expect(work.summary_title).to eq '透明な血のつながり'
      expect(work.summary).not_to be_empty
      expect(work.summary_character_count).to eq 1570
      expect(work.title).to eq '透明な血のつながり'
      expect(work.body).not_to be_empty
      expect(work.character_count).to eq 15_644
      expect(work.appeal).not_to be_empty
      expect(work.appeal_character_count).to eq 471
    end
  end
end
