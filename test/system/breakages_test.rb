require "application_system_test_case"

class BreakagesTest < ApplicationSystemTestCase
  setup do
    @breakage = breakages(:one)
  end

  test "visiting the index" do
    visit breakages_url
    assert_selector "h1", text: "Breakages"
  end

  test "should create breakage" do
    visit breakages_url
    click_on "New breakage"

    fill_in "Action taken", with: @breakage.action_taken
    check "Breakage occured" if @breakage.breakage_occured
    check "Cutting board cutting wire" if @breakage.cutting_board_cutting_wire
    check "Cutting spring" if @breakage.cutting_spring
    fill_in "Date", with: @breakage.date
    check "Knife" if @breakage.knife
    fill_in "Other desc", with: @breakage.other_desc
    fill_in "Other number", with: @breakage.other_number
    check "Product contaminated" if @breakage.product_contaminated
    check "Ringing machine cutting wire" if @breakage.ringing_machine_cutting_wire
    fill_in "Staff", with: @breakage.staff_id
    fill_in "Wire broken into 2", with: @breakage.wire_broken_into_2
    fill_in "Wire unwound", with: @breakage.wire_unwound
    click_on "Create Breakage"

    assert_text "Breakage was successfully created"
    click_on "Back"
  end

  test "should update Breakage" do
    visit breakage_url(@breakage)
    click_on "Edit this breakage", match: :first

    fill_in "Action taken", with: @breakage.action_taken
    check "Breakage occured" if @breakage.breakage_occured
    check "Cutting board cutting wire" if @breakage.cutting_board_cutting_wire
    check "Cutting spring" if @breakage.cutting_spring
    fill_in "Date", with: @breakage.date
    check "Knife" if @breakage.knife
    fill_in "Other desc", with: @breakage.other_desc
    fill_in "Other number", with: @breakage.other_number
    check "Product contaminated" if @breakage.product_contaminated
    check "Ringing machine cutting wire" if @breakage.ringing_machine_cutting_wire
    fill_in "Staff", with: @breakage.staff_id
    fill_in "Wire broken into 2", with: @breakage.wire_broken_into_2
    fill_in "Wire unwound", with: @breakage.wire_unwound
    click_on "Update Breakage"

    assert_text "Breakage was successfully updated"
    click_on "Back"
  end

  test "should destroy Breakage" do
    visit breakage_url(@breakage)
    click_on "Destroy this breakage", match: :first

    assert_text "Breakage was successfully destroyed"
  end
end
