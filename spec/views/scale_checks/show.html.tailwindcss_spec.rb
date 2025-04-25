require 'rails_helper'

RSpec.describe "scale_checks/show", type: :view do
  before(:each) do
    assign(:scale_check, ScaleCheck.create!(
      frequency: "Frequency",
      scale_name: "Scale Name",
      scale_100g: false,
      scale_500g: false,
      scale_1kg: false,
      scale_5kg: false,
      scale_10kg: false,
      comments: "Comments",
      signature: "MyText",
      staff: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Frequency/)
    expect(rendered).to match(/Scale Name/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Comments/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end
