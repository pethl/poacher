require "test_helper"

class TraceabilityRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @traceability_record = traceability_records(:one)
  end

  test "should get index" do
    get traceability_records_url
    assert_response :success
  end

  test "should get new" do
    get new_traceability_record_url
    assert_response :success
  end

  test "should create traceability_record" do
    assert_difference("TraceabilityRecord.count") do
      post traceability_records_url, params: { traceability_record: {  } }
    end

    assert_redirected_to traceability_record_url(TraceabilityRecord.last)
  end

  test "should show traceability_record" do
    get traceability_record_url(@traceability_record)
    assert_response :success
  end

  test "should get edit" do
    get edit_traceability_record_url(@traceability_record)
    assert_response :success
  end

  test "should update traceability_record" do
    patch traceability_record_url(@traceability_record), params: { traceability_record: {  } }
    assert_redirected_to traceability_record_url(@traceability_record)
  end

  test "should destroy traceability_record" do
    assert_difference("TraceabilityRecord.count", -1) do
      delete traceability_record_url(@traceability_record)
    end

    assert_redirected_to traceability_records_url
  end
end
