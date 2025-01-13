require "test_helper"

class PalletisedDistributionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @palletised_distribution = palletised_distributions(:one)
  end

  test "should get index" do
    get palletised_distributions_url
    assert_response :success
  end

  test "should get new" do
    get new_palletised_distribution_url
    assert_response :success
  end

  test "should create palletised_distribution" do
    assert_difference("PalletisedDistribution.count") do
      post palletised_distributions_url, params: { palletised_distribution: { company_name: @palletised_distribution.company_name, date: @palletised_distribution.date, destination: @palletised_distribution.destination, drivers_signature: @palletised_distribution.drivers_signature, number_of_pallets: @palletised_distribution.number_of_pallets, registration: @palletised_distribution.registration, staff_id: @palletised_distribution.staff_id, temperature: @palletised_distribution.temperature, trailer_number_type: @palletised_distribution.trailer_number_type, vehicle_clean: @palletised_distribution.vehicle_clean } }
    end

    assert_redirected_to palletised_distribution_url(PalletisedDistribution.last)
  end

  test "should show palletised_distribution" do
    get palletised_distribution_url(@palletised_distribution)
    assert_response :success
  end

  test "should get edit" do
    get edit_palletised_distribution_url(@palletised_distribution)
    assert_response :success
  end

  test "should update palletised_distribution" do
    patch palletised_distribution_url(@palletised_distribution), params: { palletised_distribution: { company_name: @palletised_distribution.company_name, date: @palletised_distribution.date, destination: @palletised_distribution.destination, drivers_signature: @palletised_distribution.drivers_signature, number_of_pallets: @palletised_distribution.number_of_pallets, registration: @palletised_distribution.registration, staff_id: @palletised_distribution.staff_id, temperature: @palletised_distribution.temperature, trailer_number_type: @palletised_distribution.trailer_number_type, vehicle_clean: @palletised_distribution.vehicle_clean } }
    assert_redirected_to palletised_distribution_url(@palletised_distribution)
  end

  test "should destroy palletised_distribution" do
    assert_difference("PalletisedDistribution.count", -1) do
      delete palletised_distribution_url(@palletised_distribution)
    end

    assert_redirected_to palletised_distributions_url
  end
end
