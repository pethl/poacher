# frozen_string_literal: true
require "rails_helper"

RSpec.describe IngredientBatchChangesHelper, type: :helper do
  let(:make_date) { Date.new(2024, 1, 10) }

   # Helper to create a valid change (ensures DI.item matches)
   def make_change(item:, date:, makesheet: nil)
    di = create(:delivery_inspection, item: item, delivery_date: date)
    create(:ingredient_batch_change,
      item: item,
      changed_on: date,
      delivery_inspection: di,
      makesheet: makesheet
    )
  end

  describe "#required_items_for" do
    let(:base_sheet) do
      create(:makesheet,
        make_type: "Standard",
        rennet_used: "Animal",
        type_of_starter_culture_used: nil,
        make_date: make_date
      )
    end

    it "defaults to RA21, Salt, and Animal rennet" do
      items = helper.required_items_for(base_sheet)
      expect(items).to include("RA21", "Salt", "Rennet - Animal")
      expect(items).not_to include("Rennet - Vegetable", "Annatto", "MD88")
    end

    it "uses RA24 when starter culture is RA24" do
      ms = create(:makesheet,
        make_type: "Standard",
        rennet_used: "Animal",
        type_of_starter_culture_used: "RA24",
        make_date: make_date
      )
      items = helper.required_items_for(ms)
      expect(items).to include("RA24", "Salt", "Rennet - Animal")
      expect(items).not_to include("RA21")
    end

    it "chooses Vegetable rennet when rennet_used is Vegetable" do
      ms = create(:makesheet,
        make_type: "Standard",
        rennet_used: "Vegetable",
        type_of_starter_culture_used: nil,
        make_date: make_date
      )
      items = helper.required_items_for(ms)
      expect(items).to include("Rennet - Vegetable")
      expect(items).not_to include("Rennet - Animal")
    end

    it "for Red make: forces Vegetable rennet and adds Annatto + MD88" do
      ms = create(:makesheet,
        make_type: "Red",
        rennet_used: "Animal",
        type_of_starter_culture_used: nil,
        make_date: make_date
      )
      items = helper.required_items_for(ms)
      expect(items).to include("Rennet - Vegetable", "Annatto", "MD88")
      expect(items).not_to include("Rennet - Animal")
    end
  end

  describe "#latest_linked_change_for" do
    let(:ms) { create(:makesheet, make_date: make_date) }

    it "returns the most recent change linked to this makesheet for the item" do
      older = make_change(item: "RA21", date: make_date - 3, makesheet: ms)
      newer = make_change(item: "RA21", date: make_date - 1, makesheet: ms)
      expect(helper.latest_linked_change_for(ms, "RA21")).to eq(newer)
    end
  end

  describe "#current_batch_change_for" do
    let(:ms) { create(:makesheet, make_date: make_date) }

    it "returns the latest change on or before the makesheet date" do
      make_change(item: "Salt", date: make_date - 10)
      winner = make_change(item: "Salt", date: make_date - 1)
      make_change(item: "Salt", date: make_date + 2) # future; ignored
      expect(helper.current_batch_change_for(ms, "Salt")).to eq(winner)
    end
  end

  describe "#display_change_for" do
    let(:ms) { create(:makesheet, make_date: make_date) }

    it "prefers the linked change when present" do
      linked = make_change(item: "Rennet - Animal", date: make_date - 5, makesheet: ms)
      make_change(item: "Rennet - Animal", date: make_date - 1) # newer global, should not win
      expect(helper.display_change_for(ms, "Rennet - Animal")).to eq(linked)
    end

    it "falls back to current-by-date when no linked change" do
      make_change(item: "RA21", date: make_date - 10)
      latest = make_change(item: "RA21", date: make_date - 2)
      expect(helper.display_change_for(ms, "RA21")).to eq(latest)
    end
  end

  describe "#latest_delivery_for_item" do
    it "delegates to DeliveryInspection scopes and returns the first result" do
      fake  = instance_double("DeliveryInspection")
      scope1 = double("scope1")
      scope2 = double("scope2")

      expect(DeliveryInspection).to receive(:for_item).with("Salt").and_return(scope1)
      expect(scope1).to receive(:by_delivery_date_desc).and_return(scope2)
      expect(scope2).to receive(:first).and_return(fake)

      expect(helper.latest_delivery_for_item("Salt")).to eq(fake)
    end
  end

  describe "#item_ever_linked?" do
    it "is true when an IngredientBatchChange exists for the item" do
      make_change(item: "MD88", date: make_date - 1)
      expect(helper.item_ever_linked?("MD88")).to be true
    end

    it "is false when no change exists for the item" do
      expect(helper.item_ever_linked?("Unseen")).to be false
    end
  end
end