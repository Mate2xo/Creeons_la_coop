# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.8'

# Rails base gems
gem 'bootstrap', '~> 4.3.1'
gem 'concurrent-ruby', '1.3.4'
gem 'image_processing', '~> 1.12'
gem 'jbuilder', '~> 2.13'
gem 'jquery-rails'
gem 'pg', '>= 1.1.4', '< 2.0'
gem 'puma', '~> 4.3'
gem 'rails', '~> 7.0'
gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.18.0', require: false

# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'mini_racer', platforms: :ruby
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 5.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'activeadmin', '~> 3.3'
gem 'active_storage_validations', '~> 1.4'
gem 'addressable', '~> 2.8.0' # URI manipulations
gem 'appsignal', '~> 4.5'
gem 'aws-sdk-s3', require: false # S3 file upload storage
gem 'bootstrap4-datetime-picker-rails'
gem 'cocoon', '~> 1.2', '>= 1.2.12' # Dynamic nested forms
gem 'devise', '~> 4.9' # Users login/registration management
gem 'devise_invitable', '~> 2.0.10'
gem 'draper' # decorators manager
gem 'dry-transaction', '0.16.0'
gem 'enumerize', '~> 2.8'
gem 'httparty' # Http requests
gem 'ice_cube' # Calendar events recurrence (for Missions)
gem 'js_cookie_rails' # Cookie manager for js
gem 'mailjet' # Production mailer API
gem 'pundit' # Authorization management
gem 'recurring_select', '~> 3.0' # Events recurrence rules set helper
gem 'thredded', '~> 1.0.0' # TODO: update me to 1.1 once upgraded to Rails 6

group :development, :test do
  gem 'bullet', '~> 7.1'
  gem 'factory_bot_rails', '~> 6.4'
  gem 'faker', '~> 3.3' # Generate fake data for the seed.rb and spec factories
  gem 'pry-byebug', '~> 3.10'
  gem 'rspec-rails', '~> 6.1'
end

group :development do
  gem 'annotate', '~> 3.1'
  gem 'letter_opener', '~> 1.10.0'
  gem 'solargraph', '~> 0.50' # LSP provinding app documention through IDE
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '~> 3.9'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'web-console', '~> 4.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '4.2.1'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.1.0'
end

group :test do
  gem 'email_spec'
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3.40.0'
  gem 'rails-controller-testing' # NOTE: the methods `render_template` and `assigns` must be replaced in order to remove this gem
  gem 'selenium-webdriver', '~> 4.32'
  gem 'shoulda-matchers', '~> 5.3' # NOTE: Update me when ugrading to Rails6.1 and Ruby3
  gem 'simplecov', require: false
end
