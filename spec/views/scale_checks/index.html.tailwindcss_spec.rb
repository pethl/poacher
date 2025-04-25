require 'rails_helper'

RSpec.describe "scale_checks/index", type: :view do
  before(:each) do
    assign(:scale_checks, [
      ScaleCheck.create!(
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
      ),
      ScaleCheck.create!(
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
      )
    ])
  end

  it "renders a list of scale_checks" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Frequency".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Scale Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Comments".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
