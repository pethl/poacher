require 'rails_helper'

RSpec.describe CleaningForeignBodyCheck, type: :model do
  describe "associations" do
    it { should belong_to(:staff).class_name('Staff').optional }
    it { should belong_to(:staff_2).class_name('Staff').with_foreign_key('staff_id_2').optional }
    it { should belong_to(:staff_3).class_name('Staff').with_foreign_key('staff_id_3').optional }
  end

  describe "validations" do
    it { should validate_presence_of(:date) }
  end

  describe "database columns" do
    it { should have_db_column(:date).of_type(:date) }
    it { should have_db_column(:milk_pipeline).of_type(:boolean) }
    it { should have_db_column(:cheese_vat).of_type(:boolean) }
    it { should have_db_column(:used_mill).of_type(:boolean) }
    it { should have_db_column(:cooler_moulds_tables).of_type(:boolean) }
    it { should have_db_column(:hand_equipment).of_type(:boolean) }
    it { should have_db_column(:blue_food_contact_equipment).of_type(:boolean) }
    it { should have_db_column(:plastic_sleeves).of_type(:boolean) }
    it { should have_db_column(:metal_shovels).of_type(:boolean) }
    it { should have_db_column(:aprons).of_type(:boolean) }
    it { should have_db_column(:drain_lower_level).of_type(:boolean) }
    it { should have_db_column(:drain_upper_level).of_type(:boolean) }
    it { should have_db_column(:presses).of_type(:boolean) }
    it { should have_db_column(:sinks).of_type(:boolean) }
    it { should have_db_column(:floor_difficult_areas).of_type(:boolean) }
    it { should have_db_column(:footbaths).of_type(:boolean) }
    it { should have_db_column(:internal_door_handles).of_type(:boolean) }
    it { should have_db_column(:change_chlorine).of_type(:boolean) }
    it { should have_db_column(:floor_under_handwash).of_type(:boolean) }
    it { should have_db_column(:compressors).of_type(:boolean) }
    it { should have_db_column(:additional_comments).of_type(:text) }
    it { should have_db_column(:staff_id).of_type(:integer) }
    it { should have_db_column(:staff_id_2).of_type(:integer) }
    it { should have_db_column(:staff_id_3).of_type(:integer) }
  end
end

