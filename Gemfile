# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.2'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.2'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

gem 'dalli'
gem 'font-awesome-sass'
gem 'omniauth'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-twitter'
gem 'open_graph_reader'
gem 'rails-i18n'
gem 'ridgepole', '>= 0.9', require: false
gem 'scout_apm'
gem 'sentry-rails'
gem 'twitter'

gem 'genron_sf', github: 'fuji-nakahara/genron_sf', require: 'genron_sf/ebook'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-rubycw', require: false
end

group :development do
  gem 'listen', '~> 3.4'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.3'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'

  gem 'bullet'
  gem 'dotenv-rails'
  gem 'rails_real_favicon'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'

  gem 'webmock'
end
