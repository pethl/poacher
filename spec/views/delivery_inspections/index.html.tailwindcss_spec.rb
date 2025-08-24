require 'rails_helper'

RSpec.describe "delivery_inspections/index", type: :view do
  before(:each) do
    assign(:delivery_inspections, [
      DeliveryInspection.create!(
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
      ),
      DeliveryInspection.create!(
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
      )
    ])
  end

  it "renders a list of delivery_inspections" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Item".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Batch No".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Staff Signature".to_s), count: 2
  end
end
