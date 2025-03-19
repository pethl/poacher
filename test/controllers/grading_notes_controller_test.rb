require "test_helper"

class GradingNotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @grading_note = grading_notes(:one)
  end

  test "should get index" do
    get grading_notes_url
    assert_response :success
  end

  test "should get new" do
    get new_grading_note_url
    assert_response :success
  end

  test "should create grading_note" do
    assert_difference("GradingNote.count") do
      post grading_notes_url, params: { grading_note: { appearance: @grading_note.appearance, assistant_taster_1: @grading_note.assistant_taster_1, assistant_taster_2: @grading_note.assistant_taster_2, bore: @grading_note.bore, date: @grading_note.date, head_taster: @grading_note.head_taster, makesheet_id: @grading_note.makesheet_id, score: @grading_note.score, taste: @grading_note.taste, texture: @grading_note.texture } }
    end

    assert_redirected_to grading_note_url(GradingNote.last)
  end

  test "should show grading_note" do
    get grading_note_url(@grading_note)
    assert_response :success
  end

  test "should get edit" do
    get edit_grading_note_url(@grading_note)
    assert_response :success
  end

  test "should update grading_note" do
    patch grading_note_url(@grading_note), params: { grading_note: { appearance: @grading_note.appearance, assistant_taster_1: @grading_note.assistant_taster_1, assistant_taster_2: @grading_note.assistant_taster_2, bore: @grading_note.bore, date: @grading_note.date, head_taster: @grading_note.head_taster, makesheet_id: @grading_note.makesheet_id, score: @grading_note.score, taste: @grading_note.taste, texture: @grading_note.texture } }
    assert_redirected_to grading_note_url(@grading_note)
  end

  test "should destroy grading_note" do
    assert_difference("GradingNote.count", -1) do
      delete grading_note_url(@grading_note)
    end

    assert_redirected_to grading_notes_url
  end
end
