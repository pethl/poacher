require "application_system_test_case"

class WashesTest < ApplicationSystemTestCase
  setup do
    @wash = washes(:one)
  end

  test "visiting the index" do
    visit washes_url
    assert_selector "h1", text: "Washes"
  end

  test "should create wash" do
    visit washes_url
    click_on "New wash"

    fill_in "Action date", with: @wash.action_date
    fill_in "Wash status", with: @wash.wash_status
    click_on "Create Wash"

    assert_text "Wash was successfully created"
    click_on "Back"
  end

  test "should update Wash" do
    visit wash_url(@wash)
    click_on "Edit this wash", match: :first

    fill_in "Action date", with: @wash.action_date
    fill_in "Wash status", with: @wash.wash_status
    click_on "Update Wash"

    assert_text "Wash was successfully updated"
    click_on "Back"
  end

  test "should destroy Wash" do
    visit wash_url(@wash)
    click_on "Destroy this wash", match: :first

    assert_text "Wash was successfully destroyed"
  end
end
