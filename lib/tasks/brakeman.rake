# frozen_string_literal: true

desc 'Run Brakeman'
task :brakeman do # rubocop:disable Rails/RakeEnvironment
  require 'brakeman'
  Brakeman.run app_path: '.', print_report: true, pager: false
end
