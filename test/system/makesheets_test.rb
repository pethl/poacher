require "application_system_test_case"

class MakesheetsTest < ApplicationSystemTestCase
  setup do
    @makesheet = makesheets(:one)
  end

  test "visiting the index" do
    visit makesheets_url
    assert_selector "h1", text: "Makesheets"
  end

  test "should create makesheet" do
    visit makesheets_url
    click_on "New makesheet"

    fill_in "Grade", with: @makesheet.grade
    fill_in "Make date", with: @makesheet.make_date
    fill_in "Milk used", with: @makesheet.milk_used
    fill_in "Number of cheeses", with: @makesheet.number_of_cheeses
    fill_in "Total weight", with: @makesheet.total_weight
    fill_in "Weight type", with: @makesheet.weight_type
    click_on "Create Makesheet"

    assert_text "Makesheet was successfully created"
    click_on "Back"
  end

  test "should update Makesheet" do
    visit makesheet_url(@makesheet)
    click_on "Edit this makesheet", match: :first

    fill_in "Grade", with: @makesheet.grade
    fill_in "Make date", with: @makesheet.make_date
    fill_in "Milk used", with: @makesheet.milk_used
    fill_in "Number of cheeses", with: @makesheet.number_of_cheeses
    fill_in "Total weight", with: @makesheet.total_weight
    fill_in "Weight type", with: @makesheet.weight_type
    click_on "Update Makesheet"

    assert_text "Makesheet was successfully updated"
    click_on "Back"
  end

  test "should destroy Makesheet" do
    visit makesheet_url(@makesheet)
    click_on "Destroy this makesheet", match: :first

    assert_text "Makesheet was successfully destroyed"
  end
end
