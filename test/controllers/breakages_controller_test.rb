require "test_helper"

class BreakagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @breakage = breakages(:one)
  end

  test "should get index" do
    get breakages_url
    assert_response :success
  end

  test "should get new" do
    get new_breakage_url
    assert_response :success
  end

  test "should create breakage" do
    assert_difference("Breakage.count") do
      post breakages_url, params: { breakage: { action_taken: @breakage.action_taken, breakage_occured: @breakage.breakage_occured, cutting_board_cutting_wire: @breakage.cutting_board_cutting_wire, cutting_spring: @breakage.cutting_spring, date: @breakage.date, knife: @breakage.knife, other_desc: @breakage.other_desc, other_number: @breakage.other_number, product_contaminated: @breakage.product_contaminated, ringing_machine_cutting_wire: @breakage.ringing_machine_cutting_wire, staff_id: @breakage.staff_id, wire_broken_into_2: @breakage.wire_broken_into_2, wire_unwound: @breakage.wire_unwound } }
    end

    assert_redirected_to breakage_url(Breakage.last)
  end

  test "should show breakage" do
    get breakage_url(@breakage)
    assert_response :success
  end

  test "should get edit" do
    get edit_breakage_url(@breakage)
    assert_response :success
  end

  test "should update breakage" do
    patch breakage_url(@breakage), params: { breakage: { action_taken: @breakage.action_taken, breakage_occured: @breakage.breakage_occured, cutting_board_cutting_wire: @breakage.cutting_board_cutting_wire, cutting_spring: @breakage.cutting_spring, date: @breakage.date, knife: @breakage.knife, other_desc: @breakage.other_desc, other_number: @breakage.other_number, product_contaminated: @breakage.product_contaminated, ringing_machine_cutting_wire: @breakage.ringing_machine_cutting_wire, staff_id: @breakage.staff_id, wire_broken_into_2: @breakage.wire_broken_into_2, wire_unwound: @breakage.wire_unwound } }
    assert_redirected_to breakage_url(@breakage)
  end

  test "should destroy breakage" do
    assert_difference("Breakage.count", -1) do
      delete breakage_url(@breakage)
    end

    assert_redirected_to breakages_url
  end
end
