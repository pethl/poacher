require "test_helper"

class ButterStocksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @butter_stock = butter_stocks(:one)
  end

  test "should get index" do
    get butter_stocks_url
    assert_response :success
  end

  test "should get new" do
    get new_butter_stock_url
    assert_response :success
  end

  test "should create butter_stock" do
    assert_difference("ButterStock.count") do
      post butter_stocks_url, params: { butter_stock: { family_butter_hm2: @butter_stock.family_butter_hm2, family_butter_salted: @butter_stock.family_butter_salted, family_butter_unsalted: @butter_stock.family_butter_unsalted, freezer_stock_hm2: @butter_stock.freezer_stock_hm2, freezer_stock_salted: @butter_stock.freezer_stock_salted, freezer_stock_unsalted: @butter_stock.freezer_stock_unsalted, fresh_spare_for_sale: @butter_stock.fresh_spare_for_sale, make_date: @butter_stock.make_date, market_returns_hm2: @butter_stock.market_returns_hm2, market_returns_salted: @butter_stock.market_returns_salted, market_returns_unsalted: @butter_stock.market_returns_unsalted, todays_make: @butter_stock.todays_make } }
    end

    assert_redirected_to butter_stock_url(ButterStock.last)
  end

  test "should show butter_stock" do
    get butter_stock_url(@butter_stock)
    assert_response :success
  end

  test "should get edit" do
    get edit_butter_stock_url(@butter_stock)
    assert_response :success
  end

  test "should update butter_stock" do
    patch butter_stock_url(@butter_stock), params: { butter_stock: { family_butter_hm2: @butter_stock.family_butter_hm2, family_butter_salted: @butter_stock.family_butter_salted, family_butter_unsalted: @butter_stock.family_butter_unsalted, freezer_stock_hm2: @butter_stock.freezer_stock_hm2, freezer_stock_salted: @butter_stock.freezer_stock_salted, freezer_stock_unsalted: @butter_stock.freezer_stock_unsalted, fresh_spare_for_sale: @butter_stock.fresh_spare_for_sale, make_date: @butter_stock.make_date, market_returns_hm2: @butter_stock.market_returns_hm2, market_returns_salted: @butter_stock.market_returns_salted, market_returns_unsalted: @butter_stock.market_returns_unsalted, todays_make: @butter_stock.todays_make } }
    assert_redirected_to butter_stock_url(@butter_stock)
  end

  test "should destroy butter_stock" do
    assert_difference("ButterStock.count", -1) do
      delete butter_stock_url(@butter_stock)
    end

    assert_redirected_to butter_stocks_url
  end
end
