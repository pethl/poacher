# frozen_string_literal: true
require "rails_helper"

RSpec.describe DeliveryInspectionsHelper, type: :helper do
  # Build a DI double that responds to the methods the helper calls
  def di_double(id:, item:, apply_hold:, assoc_loaded:, any_count:, exists_count:)
    makesheets_assoc = double("assoc", loaded?: assoc_loaded)
    makesheets_proxy = double("makesheets",
                              any?:    any_count.positive?,
                              exists?: exists_count.positive?)

    di = double("DeliveryInspection",
      id: id,
      item: item,
      apply_hold?: apply_hold,
      makesheets: makesheets_proxy
    )

    # important: stub association(:makesheets) to return our assoc double
    allow(di).to receive(:association).with(:makesheets).and_return(makesheets_assoc)
    di
  end

  describe "#di_used_any?" do
    it "uses .any? when association is loaded" do
      di = di_double(id: 1, item: "Rennet", apply_hold: false,
                     assoc_loaded: true, any_count: 2, exists_count: 0)
      expect(helper.di_used_any?(di)).to be true
    end

    it "uses .exists? when association is not loaded" do
      di = di_double(id: 1, item: "Rennet", apply_hold: false,
                     assoc_loaded: false, any_count: 0, exists_count: 1)
      expect(helper.di_used_any?(di)).to be true
    end

    it "returns false when neither any nor exists finds records" do
      di = di_double(id: 1, item: "Rennet", apply_hold: false,
                     assoc_loaded: true, any_count: 0, exists_count: 0)
      expect(helper.di_used_any?(di)).to be false
    end
  end

  describe "#di_is_current?" do
    it "compares by item and id" do
      di  = di_double(id: 42, item: "Cultures", apply_hold: false,
                      assoc_loaded: true, any_count: 0, exists_count: 0)
      map = { "Cultures" => 42 }
      expect(helper.di_is_current?(di, map)).to be true
      expect(helper.di_is_current?(di, { "Cultures" => 7 })).to be false
    end
  end

  describe "#di_row_classes" do
    it "returns the base row classes" do
      di = di_double(id: 1, item: "Salt", apply_hold: false,
                     assoc_loaded: true, any_count: 0, exists_count: 0)
      expect(helper.di_row_classes(di, {}))
        .to eq("bg-white border-b hover:bg-gray-100")
    end
  end

  describe "#current_row_first_cell_classes" do
    let(:map_current) { { "Rennet" => 5 } }

    it "returns red border when apply_hold? is true (wins over other states)" do
      di = di_double(id: 5, item: "Rennet", apply_hold: true,
                     assoc_loaded: true, any_count: 3, exists_count: 0)
      expect(helper.current_row_first_cell_classes(di, map_current))
        .to eq("border-l-4 border-red-600")
    end

    it "returns green border when current and not on hold" do
      di = di_double(id: 5, item: "Rennet", apply_hold: false,
                     assoc_loaded: true, any_count: 0, exists_count: 0)
      expect(helper.current_row_first_cell_classes(di, map_current))
        .to eq("border-l-4 border-green-500")
    end

    it "returns gray border when previously used and not current/hold" do
      di = di_double(id: 2, item: "Rennet", apply_hold: false,
                     assoc_loaded: true, any_count: 1, exists_count: 0)
      expect(helper.current_row_first_cell_classes(di, map_current))
        .to eq("border-l-4 border-gray-400")
    end

    it "returns empty string when none apply" do
      di = di_double(id: 2, item: "Rennet", apply_hold: false,
                     assoc_loaded: true, any_count: 0, exists_count: 0)
      expect(helper.current_row_first_cell_classes(di, map_current)).to eq("")
    end
  end
end
