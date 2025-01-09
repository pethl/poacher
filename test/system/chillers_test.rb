require "application_system_test_case"

class ChillersTest < ApplicationSystemTestCase
  setup do
    @chiller = chillers(:one)
  end

  test "visiting the index" do
    visit chillers_url
    assert_selector "h1", text: "Chillers"
  end

  test "should create chiller" do
    visit chillers_url
    click_on "New chiller"

    fill_in "Action taken", with: @chiller.action_taken
    fill_in "Chiller 1", with: @chiller.chiller_1
    fill_in "Chiller 2", with: @chiller.chiller_2
    fill_in "Date", with: @chiller.date
    fill_in "Staff", with: @chiller.staff_id
    click_on "Create Chiller"

    assert_text "Chiller was successfully created"
    click_on "Back"
  end

  test "should update Chiller" do
    visit chiller_url(@chiller)
    click_on "Edit this chiller", match: :first

    fill_in "Action taken", with: @chiller.action_taken
    fill_in "Chiller 1", with: @chiller.chiller_1
    fill_in "Chiller 2", with: @chiller.chiller_2
    fill_in "Date", with: @chiller.date
    fill_in "Staff", with: @chiller.staff_id
    click_on "Update Chiller"

    assert_text "Chiller was successfully updated"
    click_on "Back"
  end

  test "should destroy Chiller" do
    visit chiller_url(@chiller)
    click_on "Destroy this chiller", match: :first

    assert_text "Chiller was successfully destroyed"
  end
end
