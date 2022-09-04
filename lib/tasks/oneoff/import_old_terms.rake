# frozen_string_literal: true

namespace :oneoff do
  task import_old_terms: :environment do
    years = [2017, 2016]
    years.each { |year| Term.find_or_create_by!(year:) }
    ImportStudentsJob.perform_now(year: years)
    ImportKadaisJob.perform_now(year: years)
    ImportWorksJob.perform_now(kadais: Kadai.where(year: years).order(:year, :round))

    [
      { round: 1, selected: ['太田 知也', '火見月 侃', '天沢時生'] },
      { round: 2, selected: ['高木 刑', '火無 曜介', '兵頭 浩佑'] },
      { round: 3, selected: ['せい', '天沢時生', '高木 刑'] },
      { round: 4, selected: ['高木 刑', '吉村 りりか', '天沢時生', '火無 曜介'] },
      { round: 5, selected: ['せい', '名倉 編 a.k.a. 三三三三', '櫻木みわ'] },
      { round: 6, selected: ['天沢時生', '太田 知也', '高木 刑', 'せい'] },
      { round: 7, selected: ['高橋 文樹', '高木 刑'] },
      { round: 8, selected: ['高木 刑', '櫻木みわ', '光 レトリバー'] },
      { round: 9, selected: ['高橋 文樹', '太田 知也', '名倉 編 a.k.a. 三三三三'] },
    ].each do |result|
      Work
        .joins(:kadai, :student)
        .merge(Kadai.where(year: 2016, round: result[:round]))
        .merge(Student.where(name: result[:selected]))
        .update_all(selected: true) # rubocop:disable Rails/SkipsModelValidations
    end
  end
end
