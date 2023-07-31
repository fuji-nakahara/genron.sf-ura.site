# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 3.2.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.0.6'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.5'
# Use Puma as the app server
gem 'puma', '~> 5.6'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

gem 'barnes'
gem 'dalli'
gem 'font-awesome-sass'
gem 'omniauth'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-twitter2'
gem 'open_graph_reader'
gem 'rack-timeout'
gem 'rails-i18n'
gem 'ridgepole', '>= 0.9', require: false
gem 'scout_apm'
gem 'sentry-rails'
gem 'sentry-ruby'
gem 'simpacker'
gem 'sprockets-rails', require: 'sprockets/railtie'

gem 'genron_sf', github: 'fuji-nakahara/genron_sf', branch: 'main', require: 'genron_sf/ebook'

# For TwitterClient
gem 'faraday', '~> 2.7', require: false
gem 'simple_oauth', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  gem 'listen', '~> 3.8'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 3.1'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'

  gem 'bullet'
  gem 'dotenv-rails'
  gem 'rails_real_favicon'
  gem 'solargraph'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'

  gem 'webmock'
end
