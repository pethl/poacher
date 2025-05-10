# spec/support/capybara_helpers.rb
module CapybaraHelpers
  def safe_select(option_text, from:)
    field = find_field(from)

    # Retry until the option appears (waits up to Capybara.default_max_wait_time seconds)
    using_wait_time Capybara.default_max_wait_time do
      unless field.has_select?(option_text)
        raise Capybara::ElementNotFound, "Option '#{option_text}' not found in #{from}."
      end
    end

    select(option_text, from: from)
  rescue Capybara::ElementNotFound => e
    puts "[safe_select] Warning: #{e.message}"
    raise
  end
  def capybara_login(user)
    visit new_user_session_path

    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
  end
end
RSpec.configure do |config|
  config.include CapybaraHelpers, type: :feature
end
