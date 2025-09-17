# frozen_string_literal: true
require "rails_helper"

RSpec.describe Makesheet, type: :model do
  # baseline record; override attrs per example
  def build_ms(attrs = {})
    FactoryBot.build(
      :makesheet,
      make_date: Date.today,
      milk_used: 5000.0,
      total_weight: 4500.0
    ).tap { |m| attrs.each { |k, v| m.send("#{k}=", v) } }
  end

  # helper to stub ValidationRange.where(active: true) with plain objects
  def stub_active_ranges(*ranges)
    doubles = ranges.map do |h|
      instance_double(
        "ValidationRange",
        field_name: h.fetch(:field_name),
        min_value:  h[:min_value],
        max_value:  h[:max_value],
        active:     true
      )
    end
    allow(ValidationRange).to receive(:where).with(active: true).and_return(doubles)
  end

  describe "#validate_fields_against_ranges" do
    context "for milk_used range 4000..8000" do
      before do
        stub_active_ranges(field_name: "milk_used", min_value: 4000.0, max_value: 8000.0)
      end

      it "accepts value at min" do
        ms = build_ms(milk_used: 4000.0)
        expect(ms).to be_valid
      end

      it "accepts value at max" do
        ms = build_ms(milk_used: 8000.0)
        expect(ms).to be_valid
      end

      it "adds base error when below min" do
        ms = build_ms(milk_used: 3999.9)
        expect(ms).to be_invalid
        expect(ms.errors[:base]).to include("Milk used is below the minimum of 4000.0")
      end

      # it "adds base error when above max" do
      #   ms = build_ms(milk_used: 8000.1)
      #   expect(ms).to be_invalid
      #   expect(ms.errors[:base]).to include("Milk used is above the maximum of 8000.0")
      # end
    end

    # it "skips when value is blank or non-numeric" do
    #   stub_active_ranges(field_name: "milk_used", min_value: 1.0, max_value: 2.0)

    #   expect(build_ms(milk_used: nil)).to be_valid
    #   expect(build_ms(milk_used: "")).to be_valid
    #   expect(build_ms(milk_used: "not-a-number")).to be_valid
    # end

    it "skips when field is not an attribute on the model" do
      # Because ValidationRange model would reject this, we stub around it
      stub_active_ranges(field_name: "not_a_column", min_value: 0.0, max_value: 1.0)
      ms = build_ms
      expect(ms).to be_valid
      expect(ms.errors[:base]).to be_empty
    end

    it "ignores inactive ranges (simulated by returning empty active scope)" do
      # return no active ranges
      allow(ValidationRange).to receive(:where).with(active: true).and_return([])
      ms = build_ms(milk_used: 5000.0)
      expect(ms).to be_valid
    end

    it "accumulates errors across multiple ranged fields" do
      stub_active_ranges(
        { field_name: "milk_used",       min_value: 4000.0, max_value: 8000.0 },
        { field_name: "salt_weight_net", min_value: 5.0,    max_value: 20.0 }
      )

      ms = build_ms(milk_used: 3000.0, salt_weight_net: 25.0)
      expect(ms).to be_invalid
      expect(ms.errors[:base]).to include("Milk used is below the minimum of 4000.0")
      expect(ms.errors[:base]).to include("Salt weight net is above the maximum of 20.0")
    end
  end
end
