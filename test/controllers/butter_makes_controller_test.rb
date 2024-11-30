require "test_helper"

class ButterMakesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @butter_make = butter_makes(:one)
  end

  test "should get index" do
    get butter_makes_url
    assert_response :success
  end

  test "should get new" do
    get new_butter_make_url
    assert_response :success
  end

  test "should create butter_make" do
    assert_difference("ButterMake.count") do
      post butter_makes_url, params: { butter_make: { cream: @butter_make.cream, date: @butter_make.date, make: @butter_make.make, stock: @butter_make.stock } }
    end

    assert_redirected_to butter_make_url(ButterMake.last)
  end

  test "should show butter_make" do
    get butter_make_url(@butter_make)
    assert_response :success
  end

  test "should get edit" do
    get edit_butter_make_url(@butter_make)
    assert_response :success
  end

  test "should update butter_make" do
    patch butter_make_url(@butter_make), params: { butter_make: { cream: @butter_make.cream, date: @butter_make.date, make: @butter_make.make, stock: @butter_make.stock } }
    assert_redirected_to butter_make_url(@butter_make)
  end

  test "should destroy butter_make" do
    assert_difference("ButterMake.count", -1) do
      delete butter_make_url(@butter_make)
    end

    assert_redirected_to butter_makes_url
  end
end
