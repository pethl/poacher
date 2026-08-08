# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"

# --- SimpleCov bootstrap (must run BEFORE Rails loads) -------------------
# In GitHub Actions, ENV["CI"] == "true".
# We disable SimpleCov in CI unless SIMPLECOV_IN_CI="true".
enable_simplecov = !(ENV["CI"] == "true" && ENV["SIMPLECOV_IN_CI"] != "true")

if enable_simplecov
  require "simplecov"

  SimpleCov.start "rails" do
    SimpleCov.skip "/bin/"
    SimpleCov.skip "/db/"
    SimpleCov.skip "/spec/"
    SimpleCov.skip "/config/"

    SimpleCov.skip %r{app/.*/invoices}
    SimpleCov.skip %r{app/.*/market_sales}
    SimpleCov.skip %r{app/.*/butter_makes}
    SimpleCov.skip %r{app/.*/butter_stocks}

    enable_coverage :branch

    # Local thresholds
    # minimum_coverage 85
    minimum_coverage branch: 70
  end

  if ENV["TEST_ENV_NUMBER"]
    SimpleCov.command_name "rspec-#{ENV['TEST_ENV_NUMBER']}"
  end

  if ENV["CI"] == "true"
    SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCov::Formatter::SimpleFormatter
    ])
  end

  puts "SimpleCov started..."
end

 
# --------------------------------------------------------------------------

# Boot the Rails app
require File.expand_path("../config/environment", __dir__)

if Rails.env.production?
  puts "🚨 ABORTING: Rails is running in production mode! 🚨"
  exit(1)
end

# RSpec + test stack
require "spec_helper"
require "rspec/rails"
require "capybara/rails"
require "capybara/rspec"
require "capybara/email/rspec"

# Load support files (matchers, helpers, shared contexts, etc.)
Dir[Rails.root.join("spec", "support", "**", "*.rb")].sort.each { |f| require f }

# === RSpec Configuration ===
RSpec.configure do |config|
  # Warden/Devise: enable test mode once for the suite
  config.before(:suite) { Warden.test_mode! }

  # Include helpers
  config.include FactoryBot::Syntax::Methods
  config.include AuthHelpers, type: :feature
  # config.include FormHelpers, type: :feature

  config.include ActiveJob::TestHelper
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :feature
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Warden::Test::Helpers
  config.include Rails.application.routes.url_helpers

  # Fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.fixture_paths = ["#{::Rails.root}/spec/fixtures"]
  config.global_fixtures = :all

  # Mailer + jobs around each example
  config.before(:each) { ActionMailer::Base.deliveries.clear }
  config.around(:each) { |example| perform_enqueued_jobs { example.run } }

  # Database: transactions are great for non-JS specs.
  config.use_transactional_fixtures = true

  # Infer spec types from file paths (model/controller/request/etc.)
  config.infer_spec_type_from_file_location!

  # Clean Rails noise from backtraces
  config.filter_rails_from_backtrace!

  # Pretty output by default
  config.default_formatter = "doc"
  config.verbose_retry = false if config.respond_to?(:verbose_retry=)

  # Treat deprecations as failures (keeps codebase clean)
  config.raise_errors_for_deprecations!

  # Shoulda Matchers
  Shoulda::Matchers.configure do |shoulda_config|
    shoulda_config.integrate do |with|
      with.test_framework :rspec
      with.library :active_record
      with.library :active_model
      with.library :action_controller
    end
  end

  # Reset Warden after each example
  config.after :each do
    Warden.test_reset!
  end
end

# === Capybara Configuration ===
Capybara.register_driver :selenium_firefox do |app|
  Capybara::Selenium::Driver.new(app, browser: :firefox)
end
Capybara.javascript_driver = :selenium_firefox

# Limit massive object dumps (e.g., Capybara page bodies)
RSpec::Support::ObjectFormatter.default_instance.max_formatted_output_length = 200

# === Check for pending migrations (fail fast) ===
begin
  ActiveRecord::Migration.check_all_pending!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
