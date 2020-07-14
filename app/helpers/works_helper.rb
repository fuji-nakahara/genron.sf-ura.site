# frozen_string_literal: true

module WorksHelper
  def deadline_badge(deadline)
    deadline_time = deadline.in_time_zone.end_of_day
    return if deadline_time.past?

    bootstrap_color = case deadline_time
                      when Time.zone.now...1.day.from_now
                        'danger'
                      when 1.day.from_now...1.week.from_now
                        'warning'
                      else
                        'secondary'
                      end
    tag.span "#{distance_of_time_in_words_to_now(deadline_time)}後", class: "badge bg-#{bootstrap_color}"
  end
end
