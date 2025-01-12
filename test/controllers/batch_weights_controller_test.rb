require "test_helper"

class BatchWeightsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @batch_weight = batch_weights(:one)
  end

  test "should get index" do
    get batch_weights_url
    assert_response :success
  end

  test "should get new" do
    get new_batch_weight_url
    assert_response :success
  end

  test "should create batch_weight" do
    assert_difference("BatchWeight.count") do
      post batch_weights_url, params: { batch_weight: { all_rinds_visually_clean: @batch_weight.all_rinds_visually_clean, comments: @batch_weight.comments, date: @batch_weight.date, makesheet_id: @batch_weight.makesheet_id, washed_batch_weight: @batch_weight.washed_batch_weight } }
    end

    assert_redirected_to batch_weight_url(BatchWeight.last)
  end

  test "should show batch_weight" do
    get batch_weight_url(@batch_weight)
    assert_response :success
  end

  test "should get edit" do
    get edit_batch_weight_url(@batch_weight)
    assert_response :success
  end

  test "should update batch_weight" do
    patch batch_weight_url(@batch_weight), params: { batch_weight: { all_rinds_visually_clean: @batch_weight.all_rinds_visually_clean, comments: @batch_weight.comments, date: @batch_weight.date, makesheet_id: @batch_weight.makesheet_id, washed_batch_weight: @batch_weight.washed_batch_weight } }
    assert_redirected_to batch_weight_url(@batch_weight)
  end

  test "should destroy batch_weight" do
    assert_difference("BatchWeight.count", -1) do
      delete batch_weight_url(@batch_weight)
    end

    assert_redirected_to batch_weights_url
  end
end
