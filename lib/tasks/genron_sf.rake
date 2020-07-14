# frozen_string_literal: true

namespace :genron_sf do
  desc 'Import latest genron_sf resources and tweets newly created ones.'
  task import_latest_and_tweet: :environment do
    ImportLatestJob.perform_now(tweet: true)
  end
end
