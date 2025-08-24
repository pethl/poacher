require 'rails_helper'

RSpec.describe "delivery_inspections/new", type: :view do
  before(:each) do
    assign(:delivery_inspection, DeliveryInspection.new(
      item: "MyString",
      batch_no: "MyString",
      cert_received: false,
      damage: false,
      foreign_contam: false,
      pest_contam: false,
      timely_delivery: false,
      satisfactory: false,
      comments: "MyText",
      staff: nil,
      staff_signature: "MyString"
    ))
  end

  it "renders new delivery_inspection form" do
    render

    assert_select "form[action=?][method=?]", delivery_inspections_path, "post" do

      assert_select "input[name=?]", "delivery_inspection[item]"

      assert_select "input[name=?]", "delivery_inspection[batch_no]"

      assert_select "input[name=?]", "delivery_inspection[cert_received]"

      assert_select "input[name=?]", "delivery_inspection[damage]"

      assert_select "input[name=?]", "delivery_inspection[foreign_contam]"

      assert_select "input[name=?]", "delivery_inspection[pest_contam]"

      assert_select "input[name=?]", "delivery_inspection[timely_delivery]"

      assert_select "input[name=?]", "delivery_inspection[satisfactory]"

      assert_select "textarea[name=?]", "delivery_inspection[comments]"

      assert_select "input[name=?]", "delivery_inspection[staff_id]"

      assert_select "input[name=?]", "delivery_inspection[staff_signature]"
    end
  end
end
