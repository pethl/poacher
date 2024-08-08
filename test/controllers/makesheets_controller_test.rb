require "test_helper"

class MakesheetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @makesheet = makesheets(:one)
  end

  test "should get index" do
    get makesheets_url
    assert_response :success
  end

  test "should get new" do
    get new_makesheet_url
    assert_response :success
  end

  test "should create makesheet" do
    assert_difference("Makesheet.count") do
      post makesheets_url, params: { makesheet: { grade: @makesheet.grade, make_date: @makesheet.make_date, milk_used: @makesheet.milk_used, number_of_cheeses: @makesheet.number_of_cheeses, total_weight: @makesheet.total_weight, weight_type: @makesheet.weight_type } }
    end

    assert_redirected_to makesheet_url(Makesheet.last)
  end

  test "should show makesheet" do
    get makesheet_url(@makesheet)
    assert_response :success
  end

  test "should get edit" do
    get edit_makesheet_url(@makesheet)
    assert_response :success
  end

  test "should update makesheet" do
    patch makesheet_url(@makesheet), params: { makesheet: { grade: @makesheet.grade, make_date: @makesheet.make_date, milk_used: @makesheet.milk_used, number_of_cheeses: @makesheet.number_of_cheeses, total_weight: @makesheet.total_weight, weight_type: @makesheet.weight_type } }
    assert_redirected_to makesheet_url(@makesheet)
  end

  test "should destroy makesheet" do
    assert_difference("Makesheet.count", -1) do
      delete makesheet_url(@makesheet)
    end

    assert_redirected_to makesheets_url
  end
end
