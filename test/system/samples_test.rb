require "application_system_test_case"

class SamplesTest < ApplicationSystemTestCase
  setup do
    @sample = samples(:one)
  end

  test "visiting the index" do
    visit samples_url
    assert_selector "h1", text: "Samples"
  end

  test "should create sample" do
    visit samples_url
    click_on "New sample"

    fill_in "Coagulase positive staphylococcus 37c umqv9", with: @sample.Coagulase_positive_Staphylococcus_37C_UMQV9
    fill_in "Coagulase positive staphylococcus 37c umqzw", with: @sample.Coagulase_positive_Staphylococcus_37C_UMQZW
    fill_in "Escherichia coli b-glucuronidase", with: @sample.Escherichia_coli_B-Glucuronidase
    fill_in "Listeria species", with: @sample.Listeria_Species
    fill_in "Listeria species 37", with: @sample.Listeria_species_37
    fill_in "Presumptive coliforms", with: @sample.Presumptive_Coliforms
    fill_in "Salmonella", with: @sample.Salmonella
    fill_in "Staphylococcus aureus enterotoxins", with: @sample.Staphylococcus_aureus_enterotoxins
    fill_in "Barcode count", with: @sample.barcode_count
    fill_in "Classification", with: @sample.classification
    fill_in "Received date", with: @sample.received_date
    fill_in "Sample description", with: @sample.sample_description
    fill_in "Sample no", with: @sample.sample_no
    fill_in "Schedule", with: @sample.schedule
    fill_in "Suite", with: @sample.suite
    click_on "Create Sample"

    assert_text "Sample was successfully created"
    click_on "Back"
  end

  test "should update Sample" do
    visit sample_url(@sample)
    click_on "Edit this sample", match: :first

    fill_in "Coagulase positive staphylococcus 37c umqv9", with: @sample.Coagulase_positive_Staphylococcus_37C_UMQV9
    fill_in "Coagulase positive staphylococcus 37c umqzw", with: @sample.Coagulase_positive_Staphylococcus_37C_UMQZW
    fill_in "Escherichia coli b-glucuronidase", with: @sample.Escherichia_coli_B-Glucuronidase
    fill_in "Listeria species", with: @sample.Listeria_Species
    fill_in "Listeria species 37", with: @sample.Listeria_species_37
    fill_in "Presumptive coliforms", with: @sample.Presumptive_Coliforms
    fill_in "Salmonella", with: @sample.Salmonella
    fill_in "Staphylococcus aureus enterotoxins", with: @sample.Staphylococcus_aureus_enterotoxins
    fill_in "Barcode count", with: @sample.barcode_count
    fill_in "Classification", with: @sample.classification
    fill_in "Received date", with: @sample.received_date
    fill_in "Sample description", with: @sample.sample_description
    fill_in "Sample no", with: @sample.sample_no
    fill_in "Schedule", with: @sample.schedule
    fill_in "Suite", with: @sample.suite
    click_on "Update Sample"

    assert_text "Sample was successfully updated"
    click_on "Back"
  end

  test "should destroy Sample" do
    visit sample_url(@sample)
    click_on "Destroy this sample", match: :first

    assert_text "Sample was successfully destroyed"
  end
end
