require "application_system_test_case"

class GradingNotesTest < ApplicationSystemTestCase
  setup do
    @grading_note = grading_notes(:one)
  end

  test "visiting the index" do
    visit grading_notes_url
    assert_selector "h1", text: "Grading notes"
  end

  test "should create grading note" do
    visit grading_notes_url
    click_on "New grading note"

    fill_in "Appearance", with: @grading_note.appearance
    fill_in "Assistant taster 1", with: @grading_note.assistant_taster_1
    fill_in "Assistant taster 2", with: @grading_note.assistant_taster_2
    fill_in "Bore", with: @grading_note.bore
    fill_in "Date", with: @grading_note.date
    fill_in "Head taster", with: @grading_note.head_taster
    fill_in "Makesheet", with: @grading_note.makesheet_id
    fill_in "Score", with: @grading_note.score
    fill_in "Taste", with: @grading_note.taste
    fill_in "Texture", with: @grading_note.texture
    click_on "Create Grading note"

    assert_text "Grading note was successfully created"
    click_on "Back"
  end

  test "should update Grading note" do
    visit grading_note_url(@grading_note)
    click_on "Edit this grading note", match: :first

    fill_in "Appearance", with: @grading_note.appearance
    fill_in "Assistant taster 1", with: @grading_note.assistant_taster_1
    fill_in "Assistant taster 2", with: @grading_note.assistant_taster_2
    fill_in "Bore", with: @grading_note.bore
    fill_in "Date", with: @grading_note.date
    fill_in "Head taster", with: @grading_note.head_taster
    fill_in "Makesheet", with: @grading_note.makesheet_id
    fill_in "Score", with: @grading_note.score
    fill_in "Taste", with: @grading_note.taste
    fill_in "Texture", with: @grading_note.texture
    click_on "Update Grading note"

    assert_text "Grading note was successfully updated"
    click_on "Back"
  end

  test "should destroy Grading note" do
    visit grading_note_url(@grading_note)
    click_on "Destroy this grading note", match: :first

    assert_text "Grading note was successfully destroyed"
  end
end
