# spec/features/office_tabs_spec.rb
require 'rails_helper'

RSpec.describe 'Office tabs', type: :feature, js: true do
  let(:user) { create(:user) }

  before do
    login_as(user, scope: :user)
  end

  it 'shows Everyday by default and can switch to Administration' do
    visit pages_office_home_path

    expect(page).to have_button('Everyday')
    expect(page).to have_button('Administration')

    expect(page).to have_link('Customers')
    expect(page).to have_link('Butter Stocks')

    expect(page).not_to have_link('References')
    expect(page).not_to have_link('Calculations')

    click_button 'Administration'

    expect(page).to have_link('References')
    expect(page).to have_link('Calculations')
    expect(page).to have_link('Users')

    expect(page).not_to have_link('Customers')

    click_button 'Everyday'

    expect(page).to have_link('Customers')
    expect(page).to have_link('Samples')

    expect(page).not_to have_link('References')
    expect(page).not_to have_link('Calculations')
  end
end