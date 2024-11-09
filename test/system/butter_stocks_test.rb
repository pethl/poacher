require "application_system_test_case"

class ButterStocksTest < ApplicationSystemTestCase
  setup do
    @butter_stock = butter_stocks(:one)
  end

  test "visiting the index" do
    visit butter_stocks_url
    assert_selector "h1", text: "Butter stocks"
  end

  test "should create butter stock" do
    visit butter_stocks_url
    click_on "New butter stock"

    fill_in "Family butter hm2", with: @butter_stock.family_butter_hm2
    fill_in "Family butter salted", with: @butter_stock.family_butter_salted
    fill_in "Family butter unsalted", with: @butter_stock.family_butter_unsalted
    fill_in "Freezer stock hm2", with: @butter_stock.freezer_stock_hm2
    fill_in "Freezer stock salted", with: @butter_stock.freezer_stock_salted
    fill_in "Freezer stock unsalted", with: @butter_stock.freezer_stock_unsalted
    fill_in "Fresh spare for sale", with: @butter_stock.fresh_spare_for_sale
    fill_in "Make date", with: @butter_stock.make_date
    fill_in "Market returns hm2", with: @butter_stock.market_returns_hm2
    fill_in "Market returns salted", with: @butter_stock.market_returns_salted
    fill_in "Market returns unsalted", with: @butter_stock.market_returns_unsalted
    fill_in "Todays make", with: @butter_stock.todays_make
    click_on "Create Butter stock"

    assert_text "Butter stock was successfully created"
    click_on "Back"
  end

  test "should update Butter stock" do
    visit butter_stock_url(@butter_stock)
    click_on "Edit this butter stock", match: :first

    fill_in "Family butter hm2", with: @butter_stock.family_butter_hm2
    fill_in "Family butter salted", with: @butter_stock.family_butter_salted
    fill_in "Family butter unsalted", with: @butter_stock.family_butter_unsalted
    fill_in "Freezer stock hm2", with: @butter_stock.freezer_stock_hm2
    fill_in "Freezer stock salted", with: @butter_stock.freezer_stock_salted
    fill_in "Freezer stock unsalted", with: @butter_stock.freezer_stock_unsalted
    fill_in "Fresh spare for sale", with: @butter_stock.fresh_spare_for_sale
    fill_in "Make date", with: @butter_stock.make_date
    fill_in "Market returns hm2", with: @butter_stock.market_returns_hm2
    fill_in "Market returns salted", with: @butter_stock.market_returns_salted
    fill_in "Market returns unsalted", with: @butter_stock.market_returns_unsalted
    fill_in "Todays make", with: @butter_stock.todays_make
    click_on "Update Butter stock"

    assert_text "Butter stock was successfully updated"
    click_on "Back"
  end

  test "should destroy Butter stock" do
    visit butter_stock_url(@butter_stock)
    click_on "Destroy this butter stock", match: :first

    assert_text "Butter stock was successfully destroyed"
  end
end
