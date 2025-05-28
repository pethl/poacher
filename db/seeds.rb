# db/seeds.rb
# 🔧 Clean slate
CheeseWashRecord.destroy_all
CleaningForeignBodyCheck.destroy_all
ScaleCheck.destroy_all
WashPicksheet.destroy_all;
BatchWeight.delete_all
PicksheetItem.destroy_all;
Sample.delete_all
Chiller.destroy_all
Breakage.destroy_all
MarketSale.destroy_all
TraceabilityRecord.destroy_all;
Picksheet.destroy_all;
Turn.destroy_all;
Makesheet.destroy_all;
Calculation.destroy_all;
Reference.destroy_all;
Makesheet.delete_all
#Wash.destroy_all;
#Contact.destroy_all;
#PalletisedDistribution.destroy_all;
Staff.destroy_all;

user = User.find_or_create_by!(email: "seed@example.com") do |u|
  u.password = "password123"
  u.password_confirmation = "password123"
  u.admin = true
  u.account_active = true
end

# ✨ Modular seed files
load Rails.root.join("db/seeds/users.rb")
load Rails.root.join("db/seeds/references.rb")
load Rails.root.join("db/seeds/staff.rb")
load Rails.root.join("db/seeds/contacts.rb")
load Rails.root.join("db/seeds/calculations.rb")
load Rails.root.join("db/seeds/makesheets.rb")
load Rails.root.join("db/seeds/turns.rb")
load Rails.root.join("db/seeds/picksheets.rb")
load Rails.root.join("db/seeds/traceability_records.rb")
load Rails.root.join("db/seeds/locations.rb")

user = User.find_by(email: "pethicklisa@gmail.com")
puts "🌱 Base seed completed."
