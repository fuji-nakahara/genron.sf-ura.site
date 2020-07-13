# frozen_string_literal: true

RSpec.describe GenronSF::Subject do
  describe '.list' do
    subject(:subjects) { described_class.list(year: 2018) }

    it 'fetches the subject list page, parses its HTML and returns SubjectList instance' do
      expect(subjects.to_a.size).to eq 11

      subject10 = subjects.find { _1.number == 10 }
      expect(subject10.theme).to eq '最終課題：ゲンロンSF新人賞【梗概】'
      expect(subject10.summary_deadline.to_s).to eq '2019-03-14'
      expect(subject10.work_deadline).to be nil
      expect(subject10.without_summary?).to be false

      subject11 = subjects.find { _1.number == 11 }
      expect(subject11.theme).to eq '最終課題：ゲンロンSF新人賞【実作】'
      expect(subject11.summary_deadline).to be nil
      expect(subject11.work_deadline.to_s).to eq '2019-04-15'
      expect(subject11.without_summary?).to be true
    end
  end

  describe '.get' do
    # rubocop:disable RSpec/NamedSubject
    subject(:subject) { described_class.get(year: 2018, number: 6) }

    it 'fetches the subject page, parses its HTML and returns Subject instance' do
      expect(subject.year).to eq 2018
      expect(subject.number).to eq 6
      expect(subject.theme).to eq 'キャラクターの関係性で物語を回しなさい'
      expect(subject.detail).to start_with '現在の娯楽小説は'
      expect(subject.summary_deadline.to_s).to eq '2018-11-08'
      expect(subject.summary_comment_date.to_s).to eq '2018-11-15'
      expect(subject.work_deadline.to_s).to eq '2018-12-07'
      expect(subject.work_comment_date.to_s).to eq '2018-12-14'
      expect(subject.lecturers.to_a.size).to eq 5
      expect(subject.lecturers.map(&:name)).to match_array %w[長谷敏司 溝口力丸 飛浩隆 塩澤快浩 大森望]
      expect(subject.lecturers.find { _1.name == '長谷敏司' }.roles).to match_array %w[課題提示 梗概講評]
      expect(subject.summaries.size).to eq 26
      expect(subject.works.size).to eq 11
      expect(subject.scores.size).to eq 4
      expect(subject.scores.map(&:value)).to contain_exactly 12, 9, 1, 1
    end
    # rubocop:enable RSpec/NamedSubject
  end
end
