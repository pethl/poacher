require "test_helper"

class PicksheetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @picksheet = picksheets(:one)
  end

  test "should get index" do
    get picksheets_url
    assert_response :success
  end

  test "should get new" do
    get new_picksheet_url
    assert_response :success
  end

  test "should create picksheet" do
    assert_difference("Picksheet.count") do
      post picksheets_url, params: { picksheet: { carrier: @picksheet.carrier, carrier_delivery_date: @picksheet.carrier_delivery_date, contact_telephone_number: @picksheet.contact_telephone_number, date_order_placed: @picksheet.date_order_placed, delivery_required_by: @picksheet.delivery_required_by, invoice_number: @picksheet.invoice_number, number_of_boxes: @picksheet.number_of_boxes, order_number: @picksheet.order_number } }
    end

    assert_redirected_to picksheet_url(Picksheet.last)
  end

  test "should show picksheet" do
    get picksheet_url(@picksheet)
    assert_response :success
  end

  test "should get edit" do
    get edit_picksheet_url(@picksheet)
    assert_response :success
  end

  test "should update picksheet" do
    patch picksheet_url(@picksheet), params: { picksheet: { carrier: @picksheet.carrier, carrier_delivery_date: @picksheet.carrier_delivery_date, contact_telephone_number: @picksheet.contact_telephone_number, date_order_placed: @picksheet.date_order_placed, delivery_required_by: @picksheet.delivery_required_by, invoice_number: @picksheet.invoice_number, number_of_boxes: @picksheet.number_of_boxes, order_number: @picksheet.order_number } }
    assert_redirected_to picksheet_url(@picksheet)
  end

  test "should destroy picksheet" do
    assert_difference("Picksheet.count", -1) do
      delete picksheet_url(@picksheet)
    end

    assert_redirected_to picksheets_url
  end
end
