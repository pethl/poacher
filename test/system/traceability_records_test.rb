require "application_system_test_case"

class TraceabilityRecordsTest < ApplicationSystemTestCase
  setup do
    @traceability_record = traceability_records(:one)
  end

  test "visiting the index" do
    visit traceability_records_url
    assert_selector "h1", text: "Traceability records"
  end

  test "should create traceability record" do
    visit traceability_records_url
    click_on "New traceability record"

    click_on "Create Traceability record"

    assert_text "Traceability record was successfully created"
    click_on "Back"
  end

  test "should update Traceability record" do
    visit traceability_record_url(@traceability_record)
    click_on "Edit this traceability record", match: :first

    click_on "Update Traceability record"

    assert_text "Traceability record was successfully updated"
    click_on "Back"
  end

  test "should destroy Traceability record" do
    visit traceability_record_url(@traceability_record)
    click_on "Destroy this traceability record", match: :first

    assert_text "Traceability record was successfully destroyed"
  end
end
