# frozen_string_literal: true

namespace :genron_sf do
  desc 'Import latest genron_sf resources and tweets newly created ones.'
  task import_latest_and_tweet: :environment do
    ImportLatestJob.perform_now(tweet: true)
  end

  desc 'Import twitter_screen_names from latest year student profiles.'
  task import_twitter_screen_names: :environment do
    ImportTwitterScreenNamesJob.perform_now(year: Kadai::LATEST_YEAR)
  end

  desc 'Update users whose profile images changed'
  task update_user_images: :environment do
    UserImagesUpdateJob.perform_now
  end

  desc 'Tweet deadline expired (expected run at 00:00)'
  task tweet_deadline_expired: :environment do
    TweetDeadlineExpiredJob.perform_now(1.day.ago.to_date)
  end
end
