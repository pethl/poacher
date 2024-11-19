require "application_system_test_case"

class WasteRecordsTest < ApplicationSystemTestCase
  setup do
    @waste_record = waste_records(:one)
  end

  test "visiting the index" do
    visit waste_records_url
    assert_selector "h1", text: "Waste records"
  end

  test "should create waste record" do
    visit waste_records_url
    click_on "New waste record"

    fill_in "Blue", with: @waste_record.blue
    fill_in "Cooking", with: @waste_record.cooking
    fill_in "T and bs", with: @waste_record.t_and_bs
    fill_in "Waste", with: @waste_record.waste
    fill_in "Waste date", with: @waste_record.waste_date
    fill_in "Wedges", with: @waste_record.wedges
    click_on "Create Waste record"

    assert_text "Waste record was successfully created"
    click_on "Back"
  end

  test "should update Waste record" do
    visit waste_record_url(@waste_record)
    click_on "Edit this waste record", match: :first

    fill_in "Blue", with: @waste_record.blue
    fill_in "Cooking", with: @waste_record.cooking
    fill_in "T and bs", with: @waste_record.t_and_bs
    fill_in "Waste", with: @waste_record.waste
    fill_in "Waste date", with: @waste_record.waste_date
    fill_in "Wedges", with: @waste_record.wedges
    click_on "Update Waste record"

    assert_text "Waste record was successfully updated"
    click_on "Back"
  end

  test "should destroy Waste record" do
    visit waste_record_url(@waste_record)
    click_on "Destroy this waste record", match: :first

    assert_text "Waste record was successfully destroyed"
  end
end
