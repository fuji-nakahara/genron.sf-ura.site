# frozen_string_literal: true

namespace :genron_sf do
  desc 'Import latest genron_sf resources and tweets newly created ones.'
  task import_latest_and_tweet: :environment do
    ImportKadaisJob.perform_now
    ImportWorksJob.perform_now
    Term.find_or_create_by!(year: GenronSF::Term.latest.year)
    TweetImportedJob.perform_now
  end

  desc 'Import twitter_screen_names from latest year student profiles.'
  task import_twitter_screen_names: :environment do
    ImportTwitterScreenNamesJob.perform_now(year: Term.latest_year)
  end

  desc 'Update users whose profile images changed.'
  task update_user_images: :environment do
    UpdateUserImagesJob.perform_now
  end

  desc 'Tweet deadline expired. (expected run at 00:00)'
  task tweet_deadline_expired: :environment do
    TweetDeadlineExpiredJob.perform_now(1.day.ago.to_date)
  end

  desc 'Tweet vote results if today is comment day.'
  task tweet_vote_results: :environment do
    date = Time.zone.today
    subjects = GenronSF::Subject.list(year: Term.latest_year)
    summary_comment_subject = subjects.find { |subject| subject.summary_comment_date == date }
    if summary_comment_subject
      kadai = Kadai.find_by!(year: summary_comment_subject.year, round: summary_comment_subject.number)
      TweetVoteResultsJob.perform_now(kadai, type: 'Kougai')
    end
    work_comment_subject = subjects.find { |subject| subject.work_comment_date == date }
    if work_comment_subject
      kadai = Kadai.find_by!(year: summary_comment_subject.year, round: summary_comment_subject.number)
      TweetVoteResultsJob.perform_now(kadai, type: 'Jissaku')
    end
  end
end
