require "application_system_test_case"

class MarketSalesTest < ApplicationSystemTestCase
  setup do
    @market_sale = market_sales(:one)
  end

  test "visiting the index" do
    visit market_sales_url
    assert_selector "h1", text: "Market sales"
  end

  test "should create market sale" do
    visit market_sales_url
    click_on "New market sale"

    fill_in "Butter sales", with: @market_sale.butter_sales
    fill_in "Cheese sales", with: @market_sale.cheese_sales
    fill_in "Egg sales", with: @market_sale.egg_sales
    fill_in "Honey sales", with: @market_sale.honey_sales
    fill_in "Market", with: @market_sale.market
    fill_in "Milk", with: @market_sale.milk
    fill_in "Other cheese", with: @market_sale.other_cheese
    fill_in "Plum bread", with: @market_sale.plum_bread
    fill_in "Sale date", with: @market_sale.sale_date
    fill_in "Total sales", with: @market_sale.total_sales
    fill_in "Weight", with: @market_sale.weight
    fill_in "Who", with: @market_sale.who
    click_on "Create Market sale"

    assert_text "Market sale was successfully created"
    click_on "Back"
  end

  test "should update Market sale" do
    visit market_sale_url(@market_sale)
    click_on "Edit this market sale", match: :first

    fill_in "Butter sales", with: @market_sale.butter_sales
    fill_in "Cheese sales", with: @market_sale.cheese_sales
    fill_in "Egg sales", with: @market_sale.egg_sales
    fill_in "Honey sales", with: @market_sale.honey_sales
    fill_in "Market", with: @market_sale.market
    fill_in "Milk", with: @market_sale.milk
    fill_in "Other cheese", with: @market_sale.other_cheese
    fill_in "Plum bread", with: @market_sale.plum_bread
    fill_in "Sale date", with: @market_sale.sale_date
    fill_in "Total sales", with: @market_sale.total_sales
    fill_in "Weight", with: @market_sale.weight
    fill_in "Who", with: @market_sale.who
    click_on "Update Market sale"

    assert_text "Market sale was successfully updated"
    click_on "Back"
  end

  test "should destroy Market sale" do
    visit market_sale_url(@market_sale)
    click_on "Destroy this market sale", match: :first

    assert_text "Market sale was successfully destroyed"
  end
end
