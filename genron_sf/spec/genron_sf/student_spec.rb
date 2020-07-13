# frozen_string_literal: true

RSpec.describe GenronSF::Student do
  describe '.list' do
    subject(:students) { described_class.list(year: 2018) }

    it 'fetches the student list page, parses its HTML and returns StudentList instance' do
      expect(students.to_a.size).to eq 48
      expect(students.map(&:name)).to include 'フジ・ナカハラ'
    end
  end

  describe '.get' do
    subject(:student) { described_class.get(year: 2018, id: 'fujinakahara') }

    it 'fetches the student page, parses its HTML and returns Student instance' do
      expect(student.year).to eq 2018
      expect(student.id).to eq 'fujinakahara'
      expect(student.name).to eq 'フジ・ナカハラ'
      expect(student.profile).to eq '@fuji_nakahara https://fuji-nakahara.page/'
      expect(student.works.size).to eq 6
      expect(student.works.first.url).to eq 'https://school.genron.co.jp/works/sf/2018/students/fujinakahara/2088/'
    end
  end
end
