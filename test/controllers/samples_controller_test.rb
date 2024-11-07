require "test_helper"

class SamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sample = samples(:one)
  end

  test "should get index" do
    get samples_url
    assert_response :success
  end

  test "should get new" do
    get new_sample_url
    assert_response :success
  end

  test "should create sample" do
    assert_difference("Sample.count") do
      post samples_url, params: { sample: { Coagulase_positive_Staphylococcus_37C_UMQV9: @sample.Coagulase_positive_Staphylococcus_37C_UMQV9, Coagulase_positive_Staphylococcus_37C_UMQZW: @sample.Coagulase_positive_Staphylococcus_37C_UMQZW, Escherichia_coli_B-Glucuronidase: @sample.Escherichia_coli_B-Glucuronidase, Listeria_Species: @sample.Listeria_Species, Listeria_species_37: @sample.Listeria_species_37, Presumptive_Coliforms: @sample.Presumptive_Coliforms, Salmonella: @sample.Salmonella, Staphylococcus_aureus_enterotoxins: @sample.Staphylococcus_aureus_enterotoxins, barcode_count: @sample.barcode_count, classification: @sample.classification, received_date: @sample.received_date, sample_description: @sample.sample_description, sample_no: @sample.sample_no, schedule: @sample.schedule, suite: @sample.suite } }
    end

    assert_redirected_to sample_url(Sample.last)
  end

  test "should show sample" do
    get sample_url(@sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_sample_url(@sample)
    assert_response :success
  end

  test "should update sample" do
    patch sample_url(@sample), params: { sample: { Coagulase_positive_Staphylococcus_37C_UMQV9: @sample.Coagulase_positive_Staphylococcus_37C_UMQV9, Coagulase_positive_Staphylococcus_37C_UMQZW: @sample.Coagulase_positive_Staphylococcus_37C_UMQZW, Escherichia_coli_B-Glucuronidase: @sample.Escherichia_coli_B-Glucuronidase, Listeria_Species: @sample.Listeria_Species, Listeria_species_37: @sample.Listeria_species_37, Presumptive_Coliforms: @sample.Presumptive_Coliforms, Salmonella: @sample.Salmonella, Staphylococcus_aureus_enterotoxins: @sample.Staphylococcus_aureus_enterotoxins, barcode_count: @sample.barcode_count, classification: @sample.classification, received_date: @sample.received_date, sample_description: @sample.sample_description, sample_no: @sample.sample_no, schedule: @sample.schedule, suite: @sample.suite } }
    assert_redirected_to sample_url(@sample)
  end

  test "should destroy sample" do
    assert_difference("Sample.count", -1) do
      delete sample_url(@sample)
    end

    assert_redirected_to samples_url
  end
end
