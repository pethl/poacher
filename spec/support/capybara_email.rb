# spec/support/capybara_email.rb
RSpec.configure do |config|
  config.include Capybara::Email::DSL, type: :feature
end
