require "application_system_test_case"

class CalculationsTest < ApplicationSystemTestCase
  setup do
    @calculation = calculations(:one)
  end

  test "visiting the index" do
    visit calculations_url
    assert_selector "h1", text: "Calculations"
  end

  test "should create calculation" do
    visit calculations_url
    click_on "New calculation"

    fill_in "Notes", with: @calculation.notes
    fill_in "Product", with: @calculation.product
    fill_in "Size", with: @calculation.size
    fill_in "Weight", with: @calculation.weight
    click_on "Create Calculation"

    assert_text "Calculation was successfully created"
    click_on "Back"
  end

  test "should update Calculation" do
    visit calculation_url(@calculation)
    click_on "Edit this calculation", match: :first

    fill_in "Notes", with: @calculation.notes
    fill_in "Product", with: @calculation.product
    fill_in "Size", with: @calculation.size
    fill_in "Weight", with: @calculation.weight
    click_on "Update Calculation"

    assert_text "Calculation was successfully updated"
    click_on "Back"
  end

  test "should destroy Calculation" do
    visit calculation_url(@calculation)
    click_on "Destroy this calculation", match: :first

    assert_text "Calculation was successfully destroyed"
  end
end
