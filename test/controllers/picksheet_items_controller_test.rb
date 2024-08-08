require "test_helper"

class PicksheetItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @picksheet_item = picksheet_items(:one)
  end

  test "should get index" do
    get picksheet_items_url
    assert_response :success
  end

  test "should get new" do
    get new_picksheet_item_url
    assert_response :success
  end

  test "should create picksheet_item" do
    assert_difference("PicksheetItem.count") do
      post picksheet_items_url, params: { picksheet_item: { bb_date: @picksheet_item.bb_date, code: @picksheet_item.code, count: @picksheet_item.count, product: @picksheet_item.product, size: @picksheet_item.size, sp_price: @picksheet_item.sp_price, weight: @picksheet_item.weight } }
    end

    assert_redirected_to picksheet_item_url(PicksheetItem.last)
  end

  test "should show picksheet_item" do
    get picksheet_item_url(@picksheet_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_picksheet_item_url(@picksheet_item)
    assert_response :success
  end

  test "should update picksheet_item" do
    patch picksheet_item_url(@picksheet_item), params: { picksheet_item: { bb_date: @picksheet_item.bb_date, code: @picksheet_item.code, count: @picksheet_item.count, product: @picksheet_item.product, size: @picksheet_item.size, sp_price: @picksheet_item.sp_price, weight: @picksheet_item.weight } }
    assert_redirected_to picksheet_item_url(@picksheet_item)
  end

  test "should destroy picksheet_item" do
    assert_difference("PicksheetItem.count", -1) do
      delete picksheet_item_url(@picksheet_item)
    end

    assert_redirected_to picksheet_items_url
  end
end
