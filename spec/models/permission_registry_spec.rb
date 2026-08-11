require "rails_helper"

RSpec.describe PermissionRegistry do
  describe "RESOURCES" do
    it "maps every key to a real ActiveRecord model class" do
      PermissionRegistry::RESOURCES.each do |key, klass|
        expect(klass).to be_a(Class), "#{key.inspect} does not map to a class"
        expect(klass.ancestors).to include(ActiveRecord::Base), "#{key.inspect} (#{klass}) isn't an ActiveRecord model"
      end
    end

    it "uses snake_case string keys matching the model's underscored name" do
      PermissionRegistry::RESOURCES.each do |key, klass|
        expect(key).to eq(klass.name.underscore)
      end
    end
  end

  describe "ACTIONS" do
    it "includes the standard CRUD verbs plus the custom narrow actions" do
      expect(PermissionRegistry::ACTIONS).to include(:manage, :read, :print_labels, :link, :assign_location)
    end

    it "is frozen so it can't be mutated at runtime" do
      expect(PermissionRegistry::ACTIONS).to be_frozen
    end
  end

  it "RESOURCES is frozen so it can't be mutated at runtime" do
    expect(PermissionRegistry::RESOURCES).to be_frozen
  end
end
