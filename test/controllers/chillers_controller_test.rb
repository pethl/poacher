require "test_helper"

class ChillersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @chiller = chillers(:one)
  end

  test "should get index" do
    get chillers_url
    assert_response :success
  end

  test "should get new" do
    get new_chiller_url
    assert_response :success
  end

  test "should create chiller" do
    assert_difference("Chiller.count") do
      post chillers_url, params: { chiller: { action_taken: @chiller.action_taken, chiller_1: @chiller.chiller_1, chiller_2: @chiller.chiller_2, date: @chiller.date, staff_id: @chiller.staff_id } }
    end

    assert_redirected_to chiller_url(Chiller.last)
  end

  test "should show chiller" do
    get chiller_url(@chiller)
    assert_response :success
  end

  test "should get edit" do
    get edit_chiller_url(@chiller)
    assert_response :success
  end

  test "should update chiller" do
    patch chiller_url(@chiller), params: { chiller: { action_taken: @chiller.action_taken, chiller_1: @chiller.chiller_1, chiller_2: @chiller.chiller_2, date: @chiller.date, staff_id: @chiller.staff_id } }
    assert_redirected_to chiller_url(@chiller)
  end

  test "should destroy chiller" do
    assert_difference("Chiller.count", -1) do
      delete chiller_url(@chiller)
    end

    assert_redirected_to chillers_url
  end
end
