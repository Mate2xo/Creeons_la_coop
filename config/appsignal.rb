# https://docs.appsignal.com/ruby/configuration/options.html
Appsignal.configure do |config|
  config.activate_if_environment('staging', 'production')
  config.name = 'replace me'
  # https://docs.appsignal.com/ruby/configuration/options.html#option-push_api_key
  config.push_api_key = Rails.application.credentials.appsignal[:push_api_key]

  # https://docs.appsignal.com/ruby/configuration/ignore-actions.html
  # config.ignore_actions << "ApplicationController#isup"

  # https://docs.appsignal.com/ruby/configuration/ignore-errors.html
  # config.ignore_errors << "MyCustomError"
end
