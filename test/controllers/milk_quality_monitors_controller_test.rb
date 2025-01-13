require "test_helper"

class MilkQualityMonitorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @milk_quality_monitor = milk_quality_monitors(:one)
  end

  test "should get index" do
    get milk_quality_monitors_url
    assert_response :success
  end

  test "should get new" do
    get new_milk_quality_monitor_url
    assert_response :success
  end

  test "should create milk_quality_monitor" do
    assert_difference("MilkQualityMonitor.count") do
      post milk_quality_monitors_url, params: { milk_quality_monitor: { bactoscan: @milk_quality_monitor.bactoscan, butterfat: @milk_quality_monitor.butterfat, casein: @milk_quality_monitor.casein, cell_count: @milk_quality_monitor.cell_count, coliforms: @milk_quality_monitor.coliforms, lactose: @milk_quality_monitor.lactose, protein: @milk_quality_monitor.protein, sample_date: @milk_quality_monitor.sample_date, therms: @milk_quality_monitor.therms, total_viable_colonies: @milk_quality_monitor.total_viable_colonies, urea: @milk_quality_monitor.urea } }
    end

    assert_redirected_to milk_quality_monitor_url(MilkQualityMonitor.last)
  end

  test "should show milk_quality_monitor" do
    get milk_quality_monitor_url(@milk_quality_monitor)
    assert_response :success
  end

  test "should get edit" do
    get edit_milk_quality_monitor_url(@milk_quality_monitor)
    assert_response :success
  end

  test "should update milk_quality_monitor" do
    patch milk_quality_monitor_url(@milk_quality_monitor), params: { milk_quality_monitor: { bactoscan: @milk_quality_monitor.bactoscan, butterfat: @milk_quality_monitor.butterfat, casein: @milk_quality_monitor.casein, cell_count: @milk_quality_monitor.cell_count, coliforms: @milk_quality_monitor.coliforms, lactose: @milk_quality_monitor.lactose, protein: @milk_quality_monitor.protein, sample_date: @milk_quality_monitor.sample_date, therms: @milk_quality_monitor.therms, total_viable_colonies: @milk_quality_monitor.total_viable_colonies, urea: @milk_quality_monitor.urea } }
    assert_redirected_to milk_quality_monitor_url(@milk_quality_monitor)
  end

  test "should destroy milk_quality_monitor" do
    assert_difference("MilkQualityMonitor.count", -1) do
      delete milk_quality_monitor_url(@milk_quality_monitor)
    end

    assert_redirected_to milk_quality_monitors_url
  end
end
