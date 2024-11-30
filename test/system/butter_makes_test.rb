require "application_system_test_case"

class ButterMakesTest < ApplicationSystemTestCase
  setup do
    @butter_make = butter_makes(:one)
  end

  test "visiting the index" do
    visit butter_makes_url
    assert_selector "h1", text: "Butter makes"
  end

  test "should create butter make" do
    visit butter_makes_url
    click_on "New butter make"

    fill_in "Cream", with: @butter_make.cream
    fill_in "Date", with: @butter_make.date
    fill_in "Make", with: @butter_make.make
    fill_in "Stock", with: @butter_make.stock
    click_on "Create Butter make"

    assert_text "Butter make was successfully created"
    click_on "Back"
  end

  test "should update Butter make" do
    visit butter_make_url(@butter_make)
    click_on "Edit this butter make", match: :first

    fill_in "Cream", with: @butter_make.cream
    fill_in "Date", with: @butter_make.date
    fill_in "Make", with: @butter_make.make
    fill_in "Stock", with: @butter_make.stock
    click_on "Update Butter make"

    assert_text "Butter make was successfully updated"
    click_on "Back"
  end

  test "should destroy Butter make" do
    visit butter_make_url(@butter_make)
    click_on "Destroy this butter make", match: :first

    assert_text "Butter make was successfully destroyed"
  end
end
