# spec/support/form_helpers.rb
module FormHelpers
  def fill_in_netball_educator_form(overrides = {})
    fill_in "First Name*", with: overrides[:first_name] || "Jane"
    fill_in "Last Name*", with: overrides[:last_name] || "Doe"
    fill_in "Email*", with: overrides[:email] || "jane.doe@example.com"
    fill_in "Phone (include area code)", with: overrides[:phone] || "555-555-5555"
    fill_in "Title", with: overrides[:title] || "PE Teacher"
    fill_in "School Name*", with: overrides[:school_name] || "Sample Academy"
    fill_in "School Address", with: overrides[:address] || "1234 Sample St"
    fill_in "City*", with: overrides[:city] || "Miami"
    select overrides[:state] || "Florida", from: "State"
    fill_in "Zip Code", with: overrides[:zip] || "33101"
    fill_in "School Website", with: overrides[:website] || "http://school.edu"
    select overrides[:level] || "High School", from: "Level"
    fill_in "What would you like more information on?", with: overrides[:educator_notes] || "More programs"
    fill_in "Quote/Feedback on your session", with: overrides[:feedback] || "Great workshop!"
    check "Do you authorize us to use feedback on social media?" if overrides.fetch(:authorize, true)
  end
end
