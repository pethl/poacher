require "application_system_test_case"

class ContactsTest < ApplicationSystemTestCase
  setup do
    @contact = contacts(:one)
  end

  test "visiting the index" do
    visit contacts_url
    assert_selector "h1", text: "Contacts"
  end

  test "should create contact" do
    visit contacts_url
    click_on "New contact"

    fill_in "Address", with: @contact.address
    fill_in "Business name", with: @contact.business_name
    fill_in "Contact name", with: @contact.contact_name
    fill_in "Country", with: @contact.country
    fill_in "Email", with: @contact.email
    fill_in "Mobile", with: @contact.mobile
    fill_in "Notes", with: @contact.notes
    fill_in "Phone", with: @contact.phone
    fill_in "Reference", with: @contact.reference
    click_on "Create Contact"

    assert_text "Contact was successfully created"
    click_on "Back"
  end

  test "should update Contact" do
    visit contact_url(@contact)
    click_on "Edit this contact", match: :first

    fill_in "Address", with: @contact.address
    fill_in "Business name", with: @contact.business_name
    fill_in "Contact name", with: @contact.contact_name
    fill_in "Country", with: @contact.country
    fill_in "Email", with: @contact.email
    fill_in "Mobile", with: @contact.mobile
    fill_in "Notes", with: @contact.notes
    fill_in "Phone", with: @contact.phone
    fill_in "Reference", with: @contact.reference
    click_on "Update Contact"

    assert_text "Contact was successfully updated"
    click_on "Back"
  end

  test "should destroy Contact" do
    visit contact_url(@contact)
    click_on "Destroy this contact", match: :first

    assert_text "Contact was successfully destroyed"
  end
end
