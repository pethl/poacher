require "test_helper"

class WasteRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @waste_record = waste_records(:one)
  end

  test "should get index" do
    get waste_records_url
    assert_response :success
  end

  test "should get new" do
    get new_waste_record_url
    assert_response :success
  end

  test "should create waste_record" do
    assert_difference("WasteRecord.count") do
      post waste_records_url, params: { waste_record: { blue: @waste_record.blue, cooking: @waste_record.cooking, t_and_bs: @waste_record.t_and_bs, waste: @waste_record.waste, waste_date: @waste_record.waste_date, wedges: @waste_record.wedges } }
    end

    assert_redirected_to waste_record_url(WasteRecord.last)
  end

  test "should show waste_record" do
    get waste_record_url(@waste_record)
    assert_response :success
  end

  test "should get edit" do
    get edit_waste_record_url(@waste_record)
    assert_response :success
  end

  test "should update waste_record" do
    patch waste_record_url(@waste_record), params: { waste_record: { blue: @waste_record.blue, cooking: @waste_record.cooking, t_and_bs: @waste_record.t_and_bs, waste: @waste_record.waste, waste_date: @waste_record.waste_date, wedges: @waste_record.wedges } }
    assert_redirected_to waste_record_url(@waste_record)
  end

  test "should destroy waste_record" do
    assert_difference("WasteRecord.count", -1) do
      delete waste_record_url(@waste_record)
    end

    assert_redirected_to waste_records_url
  end
end
