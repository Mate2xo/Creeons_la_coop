# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CreonsLaCoop
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.

    config.i18n.available_locales = %i[en fr]
    config.i18n.default_locale = :fr
    config.i18n.load_path += Dir[Rails.root.join('config/locales/**/*.{rb,yml}')]

    config.autoloader = :zeitwerk
  end
end
