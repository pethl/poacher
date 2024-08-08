require "application_system_test_case"

class PicksheetsTest < ApplicationSystemTestCase
  setup do
    @picksheet = picksheets(:one)
  end

  test "visiting the index" do
    visit picksheets_url
    assert_selector "h1", text: "Picksheets"
  end

  test "should create picksheet" do
    visit picksheets_url
    click_on "New picksheet"

    fill_in "Carrier", with: @picksheet.carrier
    fill_in "Carrier delivery date", with: @picksheet.carrier_delivery_date
    fill_in "Contact telephone number", with: @picksheet.contact_telephone_number
    fill_in "Date order placed", with: @picksheet.date_order_placed
    fill_in "Delivery required by", with: @picksheet.delivery_required_by
    fill_in "Invoice number", with: @picksheet.invoice_number
    fill_in "Number of boxes", with: @picksheet.number_of_boxes
    fill_in "Order number", with: @picksheet.order_number
    click_on "Create Picksheet"

    assert_text "Picksheet was successfully created"
    click_on "Back"
  end

  test "should update Picksheet" do
    visit picksheet_url(@picksheet)
    click_on "Edit this picksheet", match: :first

    fill_in "Carrier", with: @picksheet.carrier
    fill_in "Carrier delivery date", with: @picksheet.carrier_delivery_date
    fill_in "Contact telephone number", with: @picksheet.contact_telephone_number
    fill_in "Date order placed", with: @picksheet.date_order_placed
    fill_in "Delivery required by", with: @picksheet.delivery_required_by
    fill_in "Invoice number", with: @picksheet.invoice_number
    fill_in "Number of boxes", with: @picksheet.number_of_boxes
    fill_in "Order number", with: @picksheet.order_number
    click_on "Update Picksheet"

    assert_text "Picksheet was successfully updated"
    click_on "Back"
  end

  test "should destroy Picksheet" do
    visit picksheet_url(@picksheet)
    click_on "Destroy this picksheet", match: :first

    assert_text "Picksheet was successfully destroyed"
  end
end
