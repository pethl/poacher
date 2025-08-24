require 'rails_helper'

RSpec.describe "delivery_inspections/show", type: :view do
  before(:each) do
    assign(:delivery_inspection, DeliveryInspection.create!(
      item: "Item",
      batch_no: "Batch No",
      cert_received: false,
      damage: false,
      foreign_contam: false,
      pest_contam: false,
      timely_delivery: false,
      satisfactory: false,
      comments: "MyText",
      staff: nil,
      staff_signature: "Staff Signature"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Item/)
    expect(rendered).to match(/Batch No/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Staff Signature/)
  end
end
