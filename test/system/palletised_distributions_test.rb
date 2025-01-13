require "application_system_test_case"

class PalletisedDistributionsTest < ApplicationSystemTestCase
  setup do
    @palletised_distribution = palletised_distributions(:one)
  end

  test "visiting the index" do
    visit palletised_distributions_url
    assert_selector "h1", text: "Palletised distributions"
  end

  test "should create palletised distribution" do
    visit palletised_distributions_url
    click_on "New palletised distribution"

    fill_in "Company name", with: @palletised_distribution.company_name
    fill_in "Date", with: @palletised_distribution.date
    fill_in "Destination", with: @palletised_distribution.destination
    fill_in "Drivers signature", with: @palletised_distribution.drivers_signature
    fill_in "Number of pallets", with: @palletised_distribution.number_of_pallets
    fill_in "Registration", with: @palletised_distribution.registration
    fill_in "Staff", with: @palletised_distribution.staff_id
    fill_in "Temperature", with: @palletised_distribution.temperature
    fill_in "Trailer number type", with: @palletised_distribution.trailer_number_type
    check "Vehicle clean" if @palletised_distribution.vehicle_clean
    click_on "Create Palletised distribution"

    assert_text "Palletised distribution was successfully created"
    click_on "Back"
  end

  test "should update Palletised distribution" do
    visit palletised_distribution_url(@palletised_distribution)
    click_on "Edit this palletised distribution", match: :first

    fill_in "Company name", with: @palletised_distribution.company_name
    fill_in "Date", with: @palletised_distribution.date
    fill_in "Destination", with: @palletised_distribution.destination
    fill_in "Drivers signature", with: @palletised_distribution.drivers_signature
    fill_in "Number of pallets", with: @palletised_distribution.number_of_pallets
    fill_in "Registration", with: @palletised_distribution.registration
    fill_in "Staff", with: @palletised_distribution.staff_id
    fill_in "Temperature", with: @palletised_distribution.temperature
    fill_in "Trailer number type", with: @palletised_distribution.trailer_number_type
    check "Vehicle clean" if @palletised_distribution.vehicle_clean
    click_on "Update Palletised distribution"

    assert_text "Palletised distribution was successfully updated"
    click_on "Back"
  end

  test "should destroy Palletised distribution" do
    visit palletised_distribution_url(@palletised_distribution)
    click_on "Destroy this palletised distribution", match: :first

    assert_text "Palletised distribution was successfully destroyed"
  end
end
