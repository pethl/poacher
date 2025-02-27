require 'logger'
require 'active_support'
require_relative "boot"
require "rails/all"
require "csv"
require 'roo'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Poacher
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.autoload_paths << Rails.root.join('app/pdfs')

    # Added to assit with loading animation.js
    config.assets.paths << Rails.root.join("app", "assets", "builds")

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    config.eager_load_paths << Rails.root.join("extras")
    #config.autoload_paths << "#{Rails.root}/extras"
    #config.eager_load_paths << "#{Rails.root}/extras"
    
    
  end
end
