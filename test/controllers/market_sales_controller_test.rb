require "test_helper"

class MarketSalesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @market_sale = market_sales(:one)
  end

  test "should get index" do
    get market_sales_url
    assert_response :success
  end

  test "should get new" do
    get new_market_sale_url
    assert_response :success
  end

  test "should create market_sale" do
    assert_difference("MarketSale.count") do
      post market_sales_url, params: { market_sale: { butter_sales: @market_sale.butter_sales, cheese_sales: @market_sale.cheese_sales, egg_sales: @market_sale.egg_sales, honey_sales: @market_sale.honey_sales, market: @market_sale.market, milk: @market_sale.milk, other_cheese: @market_sale.other_cheese, plum_bread: @market_sale.plum_bread, sale_date: @market_sale.sale_date, total_sales: @market_sale.total_sales, weight: @market_sale.weight, who: @market_sale.who } }
    end

    assert_redirected_to market_sale_url(MarketSale.last)
  end

  test "should show market_sale" do
    get market_sale_url(@market_sale)
    assert_response :success
  end

  test "should get edit" do
    get edit_market_sale_url(@market_sale)
    assert_response :success
  end

  test "should update market_sale" do
    patch market_sale_url(@market_sale), params: { market_sale: { butter_sales: @market_sale.butter_sales, cheese_sales: @market_sale.cheese_sales, egg_sales: @market_sale.egg_sales, honey_sales: @market_sale.honey_sales, market: @market_sale.market, milk: @market_sale.milk, other_cheese: @market_sale.other_cheese, plum_bread: @market_sale.plum_bread, sale_date: @market_sale.sale_date, total_sales: @market_sale.total_sales, weight: @market_sale.weight, who: @market_sale.who } }
    assert_redirected_to market_sale_url(@market_sale)
  end

  test "should destroy market_sale" do
    assert_difference("MarketSale.count", -1) do
      delete market_sale_url(@market_sale)
    end

    assert_redirected_to market_sales_url
  end
end
