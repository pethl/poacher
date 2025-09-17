# frozen_string_literal: true

require "rails_helper"

RSpec.describe Location, type: :model do
  subject(:location) { build(:location) }

  describe "associations" do
    it { is_expected.to have_one(:makesheet) }
    it { is_expected.to have_many(:all_makesheets).class_name("Makesheet") }
    it { is_expected.to belong_to(:created_by).class_name("User").optional }
    it { is_expected.to belong_to(:updated_by).class_name("User").optional }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:sort_order) }
  
    describe "uniqueness" do
      let!(:existing) { create(:location, name: "Spec Unique Name", sort_order: 30_000) }
  
      it "validates uniqueness of name" do
        dup = build(:location, name: existing.name)
        expect(dup).not_to be_valid
        expect(dup.errors[:name]).to include("has already been taken")
      end
  
      it "validates uniqueness of sort_order" do
        dup = build(:location, sort_order: existing.sort_order)
        expect(dup).not_to be_valid
        expect(dup.errors[:sort_order]).to include("has already been taken")
      end
    end
  end
  

  describe "scopes" do
    it ".active returns only active locations" do
      active_loc   = create(:location, active: true,  sort_order: 20_001, name: "Spec Active 1")
      inactive_loc = create(:location, :inactive,     sort_order: 20_002, name: "Spec Inactive 1")
  
      # Limit the universe to just the records we created
      scoped = Location.where(id: [active_loc.id, inactive_loc.id])
  
      expect(scoped.active).to contain_exactly(active_loc)
      expect(scoped.active).not_to include(inactive_loc)
    end
  
    it ".active_sorted orders by sort_order ascending" do
      l3 = create(:location, sort_order: 20_003, name: "Spec L3") # active true by default
      l1 = create(:location, sort_order: 20_001, name: "Spec L1")
      l2 = create(:location, sort_order: 20_002, name: "Spec L2")
  
      scoped = Location.where(id: [l1.id, l2.id, l3.id])
  
      expect(scoped.active_sorted).to eq([l1, l2, l3])
    end
  end
  

  describe "parsing helpers" do
    context "#shed" do
      it "returns the shed number as a string when present" do
        loc = build(:location, :shed, shed_num: 5)
        expect(loc.shed).to eq("5") # NOTE: string by design
      end

      it "returns nil when not a shed location" do
        expect(location.shed).to be_nil
      end
    end

    context "#shed_number" do
      it "returns the shed number as integer when present" do
        loc = build(:location, :shed, shed_num: 7)
        expect(loc.shed_number).to eq(7)
      end

      it "returns nil when not a shed" do
        expect(location.shed_number).to be_nil
      end
    end

    context "#aisle" do
      it "extracts the aisle number as integer" do
        loc = build(:location, :aisle, aisle_num: 12, side_val: "Right")
        expect(loc.aisle).to eq(12)
      end

      it "returns nil if no aisle present" do
        loc = build(:location, name: "Shed 1 - Col 3")
        expect(loc.aisle).to be_nil
      end
    end

    context "#side" do
      it "extracts the side (Left/Right)" do
        loc = build(:location, :aisle, side_val: "Right")
        expect(loc.side).to eq("Right")
      end

      it "returns nil if no side present" do
        loc = build(:location, name: "Aisle 2 Col 10")
        expect(loc.side).to be_nil
      end
    end

    context "#row_label" do
      it "returns 'Aisle X Side' when aisle and side are present" do
        loc = build(:location, :aisle, aisle_num: 4, side_val: "Left")
        expect(loc.row_label).to eq("Aisle 4 Left")
      end

      it "returns nil when either piece missing" do
        expect(build(:location, name: "Aisle 9 Col 1").row_label).to be_nil
        expect(build(:location, name: "Left Col 1").row_label).to be_nil
      end
    end

    context "#column_number" do
      it "handles 'Col 3'" do
        loc = build(:location, name: "Aisle 1 Left Col 3")
        expect(loc.column_number).to eq(3)
      end

      it "handles compact 'Col3'" do
        loc = build(:location, :column_compact)
        expect(loc.column_number).to eq(3)
      end

      it "handles dashed 'Col-7'" do
        loc = build(:location, :column_dash)
        expect(loc.column_number).to eq(7)
      end

      it "handles 'Column 10'" do
        loc = build(:location, name: "Aisle 1 Right Column 10")
        expect(loc.column_number).to eq(10)
      end

      it "returns nil if not numeric" do
        loc = build(:location, :column_label_alpha)
        expect(loc.column_number).to be_nil
      end
    end

    context "#column_label" do
      it "returns uppercase numeric label" do
        loc = build(:location, name: "Aisle 1 Right Column 12")
        expect(loc.column_label).to eq("12")
      end

      it "returns uppercase alpha label" do
        loc = build(:location, :column_label_alpha)
        expect(loc.column_label).to eq("B")
      end

      it "handles dashed and compact variants" do
        expect(build(:location, :column_dash).column_label).to eq("7")
        expect(build(:location, :column_compact).column_label).to eq("3")
      end

      it "returns nil when column not present" do
        loc = build(:location, name: "Aisle 2 Left")
        expect(loc.column_label).to be_nil
      end
    end

    context "#trolley_number" do
      it "extracts trolley number as integer" do
        loc = build(:location, :trolley, trolley_num: 9)
        expect(loc.trolley_number).to eq(9)
      end

      it "returns nil when trolley not present" do
        expect(location.trolley_number).to be_nil
      end
    end
  end
end

