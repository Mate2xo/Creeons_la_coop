# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CreonsLaCoop
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[active_admin assets tasks])
    # config.eager_load_paths << Rails.root.join("extras")

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.

    config.i18n.available_locales = %i[en fr]
    config.i18n.default_locale = :fr
    config.i18n.load_path += Rails.root.glob('config/locales/**/*.{rb,yml}')
    # config.time_zone = "Central Time (US & Canada)"
    config.active_model.i18n_customize_full_message = true

    # TODO: :vips is more performant. See
    # https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#active-storage-default-variant-processor-changed-to-vips
    config.active_storage.variant_processor = :mini_magick
  end
end
