require "application_system_test_case"

class MilkQualityMonitorsTest < ApplicationSystemTestCase
  setup do
    @milk_quality_monitor = milk_quality_monitors(:one)
  end

  test "visiting the index" do
    visit milk_quality_monitors_url
    assert_selector "h1", text: "Milk quality monitors"
  end

  test "should create milk quality monitor" do
    visit milk_quality_monitors_url
    click_on "New milk quality monitor"

    fill_in "Bactoscan", with: @milk_quality_monitor.bactoscan
    fill_in "Butterfat", with: @milk_quality_monitor.butterfat
    fill_in "Casein", with: @milk_quality_monitor.casein
    fill_in "Cell count", with: @milk_quality_monitor.cell_count
    fill_in "Coliforms", with: @milk_quality_monitor.coliforms
    fill_in "Lactose", with: @milk_quality_monitor.lactose
    fill_in "Protein", with: @milk_quality_monitor.protein
    fill_in "Sample date", with: @milk_quality_monitor.sample_date
    fill_in "Therms", with: @milk_quality_monitor.therms
    fill_in "Total viable colonies", with: @milk_quality_monitor.total_viable_colonies
    fill_in "Urea", with: @milk_quality_monitor.urea
    click_on "Create Milk quality monitor"

    assert_text "Milk quality monitor was successfully created"
    click_on "Back"
  end

  test "should update Milk quality monitor" do
    visit milk_quality_monitor_url(@milk_quality_monitor)
    click_on "Edit this milk quality monitor", match: :first

    fill_in "Bactoscan", with: @milk_quality_monitor.bactoscan
    fill_in "Butterfat", with: @milk_quality_monitor.butterfat
    fill_in "Casein", with: @milk_quality_monitor.casein
    fill_in "Cell count", with: @milk_quality_monitor.cell_count
    fill_in "Coliforms", with: @milk_quality_monitor.coliforms
    fill_in "Lactose", with: @milk_quality_monitor.lactose
    fill_in "Protein", with: @milk_quality_monitor.protein
    fill_in "Sample date", with: @milk_quality_monitor.sample_date
    fill_in "Therms", with: @milk_quality_monitor.therms
    fill_in "Total viable colonies", with: @milk_quality_monitor.total_viable_colonies
    fill_in "Urea", with: @milk_quality_monitor.urea
    click_on "Update Milk quality monitor"

    assert_text "Milk quality monitor was successfully updated"
    click_on "Back"
  end

  test "should destroy Milk quality monitor" do
    visit milk_quality_monitor_url(@milk_quality_monitor)
    click_on "Destroy this milk quality monitor", match: :first

    assert_text "Milk quality monitor was successfully destroyed"
  end
end
