# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

# --- SimpleCov: start BEFORE loading the Rails app ---
require 'simplecov'
SimpleCov.start 'rails' do
  add_filter '/bin/'
  add_filter '/db/'
  add_filter '/spec/' # Don't track spec files
  enable_coverage :branch
end

# ✅ Only enforce coverage thresholds on CI or when explicitly opted in
if ENV['CI'] || ENV['ENFORCE_MIN_COVERAGE'] == '1'
  SimpleCov.minimum_coverage line: 85, branch: 70
  SimpleCov.refuse_coverage_drop
end

# If you ever run specs in parallel (e.g. with 'parallel_tests'),
# give each process a unique name so coverage can be merged.
if ENV['TEST_ENV_NUMBER']
  SimpleCov.command_name "rspec-#{ENV['TEST_ENV_NUMBER']}"
end

# On CI, also print a brief text summary alongside HTML
if ENV['CI']
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::SimpleFormatter
  ])
end

puts 'SimpleCov started...'
# --- end SimpleCov ---


# Boot the Rails app
require File.expand_path('../config/environment', __dir__)

if Rails.env.production?
  puts '🚨 ABORTING: Rails is running in production mode! 🚨'
  exit(1)
end

# RSpec + test stack
require 'spec_helper'
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/email/rspec'

# Load support files (matchers, helpers, shared contexts, etc.)
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

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
  # If you have JS/system specs that need DB visibility across threads,
  # we can switch those to use truncation just for `js: true`.
  config.use_transactional_fixtures = true

  # Infer spec types from file paths (model/controller/request/etc.)
  config.infer_spec_type_from_file_location!

  # Clean Rails noise from backtraces
  config.filter_rails_from_backtrace!

  # Pretty output by default
  config.default_formatter = 'doc'
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
