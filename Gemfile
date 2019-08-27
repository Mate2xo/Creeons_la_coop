# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'bootstrap', '~> 4.3.1'
gem 'erd', '~> 0.6.3'
gem 'jquery-rails'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2', '>= 5.2.3'
gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use ActiveStorage variant
gem 'mini_magick', '~> 4.9.5'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Admin interface
gem 'activeadmin'
# Authorization management
gem 'pundit'
# Users login/registration management
gem "devise", "~> 4.6"
gem 'devise_invitable', '~> 2.0.0'
# Calendar events recurrence (for Missions)
gem 'ice_cube'
gem 'recurring_select'
# Dynamic nested forms
gem 'cocoon', '~> 1.2', '>= 1.2.12'
# Generate fake data for the seed.rb and spec factories
gem 'faker'
# Production Mailer API
gem 'mailjet'
# Http requests
gem 'httparty'
# URI manipulations
gem 'addressable'
# S3 file upload storage
gem "aws-sdk-s3", require: false
# Map generator
gem 'leaflet-rails'

group :development, :test do
  gem 'factory_bot_rails', '~> 4.0'
  gem 'guard-rspec', require: false
  gem 'pry-byebug', '~> 3.6'
  gem 'rspec-rails', '~> 3.7', '>= 3.7.2'
end

group :development do
  gem 'annotate', '~> 2.7', '>= 2.7.4'
  gem 'letter_opener'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop', '~> 0.63.0', require: false
  gem 'rubocop-rspec', '~> 1.31.0'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'email_spec'
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
  # Easy database + association testing
  gem 'database_cleaner'
  gem 'rails-controller-testing' # If you are using Rails 5.x
  gem 'shoulda-matchers', '4.0.0.rc1'
  gem 'simplecov', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
