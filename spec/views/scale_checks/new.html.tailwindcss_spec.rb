require 'rails_helper'

RSpec.describe "scale_checks/new", type: :view do
  before(:each) do
    assign(:scale_check, ScaleCheck.new(
      frequency: "MyString",
      scale_name: "MyString",
      scale_100g: false,
      scale_500g: false,
      scale_1kg: false,
      scale_5kg: false,
      scale_10kg: false,
      comments: "MyString",
      signature: "MyText",
      staff: nil
    ))
  end

  it "renders new scale_check form" do
    render

    assert_select "form[action=?][method=?]", scale_checks_path, "post" do

      assert_select "input[name=?]", "scale_check[frequency]"

      assert_select "input[name=?]", "scale_check[scale_name]"

      assert_select "input[name=?]", "scale_check[scale_100g]"

      assert_select "input[name=?]", "scale_check[scale_500g]"

      assert_select "input[name=?]", "scale_check[scale_1kg]"

      assert_select "input[name=?]", "scale_check[scale_5kg]"

      assert_select "input[name=?]", "scale_check[scale_10kg]"

      assert_select "input[name=?]", "scale_check[comments]"

      assert_select "textarea[name=?]", "scale_check[signature]"

      assert_select "input[name=?]", "scale_check[staff_id]"
    end
  end
end
