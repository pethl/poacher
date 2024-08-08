require "application_system_test_case"

class PicksheetItemsTest < ApplicationSystemTestCase
  setup do
    @picksheet_item = picksheet_items(:one)
  end

  test "visiting the index" do
    visit picksheet_items_url
    assert_selector "h1", text: "Picksheet items"
  end

  test "should create picksheet item" do
    visit picksheet_items_url
    click_on "New picksheet item"

    fill_in "Bb date", with: @picksheet_item.bb_date
    fill_in "Code", with: @picksheet_item.code
    fill_in "Count", with: @picksheet_item.count
    fill_in "Product", with: @picksheet_item.product
    fill_in "Size", with: @picksheet_item.size
    fill_in "Sp price", with: @picksheet_item.sp_price
    fill_in "Weight", with: @picksheet_item.weight
    click_on "Create Picksheet item"

    assert_text "Picksheet item was successfully created"
    click_on "Back"
  end

  test "should update Picksheet item" do
    visit picksheet_item_url(@picksheet_item)
    click_on "Edit this picksheet item", match: :first

    fill_in "Bb date", with: @picksheet_item.bb_date
    fill_in "Code", with: @picksheet_item.code
    fill_in "Count", with: @picksheet_item.count
    fill_in "Product", with: @picksheet_item.product
    fill_in "Size", with: @picksheet_item.size
    fill_in "Sp price", with: @picksheet_item.sp_price
    fill_in "Weight", with: @picksheet_item.weight
    click_on "Update Picksheet item"

    assert_text "Picksheet item was successfully updated"
    click_on "Back"
  end

  test "should destroy Picksheet item" do
    visit picksheet_item_url(@picksheet_item)
    click_on "Destroy this picksheet item", match: :first

    assert_text "Picksheet item was successfully destroyed"
  end
end
