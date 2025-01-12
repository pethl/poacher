require "application_system_test_case"

class BatchWeightsTest < ApplicationSystemTestCase
  setup do
    @batch_weight = batch_weights(:one)
  end

  test "visiting the index" do
    visit batch_weights_url
    assert_selector "h1", text: "Batch weights"
  end

  test "should create batch weight" do
    visit batch_weights_url
    click_on "New batch weight"

    fill_in "All rinds visually clean", with: @batch_weight.all_rinds_visually_clean
    fill_in "Comments", with: @batch_weight.comments
    fill_in "Date", with: @batch_weight.date
    fill_in "Makesheet", with: @batch_weight.makesheet_id
    fill_in "Washed batch weight", with: @batch_weight.washed_batch_weight
    click_on "Create Batch weight"

    assert_text "Batch weight was successfully created"
    click_on "Back"
  end

  test "should update Batch weight" do
    visit batch_weight_url(@batch_weight)
    click_on "Edit this batch weight", match: :first

    fill_in "All rinds visually clean", with: @batch_weight.all_rinds_visually_clean
    fill_in "Comments", with: @batch_weight.comments
    fill_in "Date", with: @batch_weight.date
    fill_in "Makesheet", with: @batch_weight.makesheet_id
    fill_in "Washed batch weight", with: @batch_weight.washed_batch_weight
    click_on "Update Batch weight"

    assert_text "Batch weight was successfully updated"
    click_on "Back"
  end

  test "should destroy Batch weight" do
    visit batch_weight_url(@batch_weight)
    click_on "Destroy this batch weight", match: :first

    assert_text "Batch weight was successfully destroyed"
  end
end
