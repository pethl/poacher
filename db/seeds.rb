# db/seeds.rb
# 🔧 Clean slate
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
load Rails.root.join("db/seeds/references.rb")
load Rails.root.join("db/seeds/staff.rb")
load Rails.root.join("db/seeds/contacts.rb")
load Rails.root.join("db/seeds/calculations.rb")
load Rails.root.join("db/seeds/makesheets.rb")
load Rails.root.join("db/seeds/turns.rb")
load Rails.root.join("db/seeds/picksheets.rb")


#User.create(username:"LisaPethick", encrypted_password:"$2a$12$1AUJnNk3txhOTBrytYuSfuTCwQeHjzo6E3d7nKvPyQ/aL.XiD099y", admin:"TRUE", account_active:"TRUE");
# #salesix = Picksheet.create(date_order_placed:'14/11/2024', delivery_required_by: '17/11/2024', order_number: 'PD123459', contact_telephone_number: '07803 293 666', invoice_number: '6674880', carrier: 'DPD', carrier_delivery_date:'03/07/2024',number_of_boxes: 2);
#PicksheetItem.create(picksheet:saleone.id, product: 'Poacher', size: 'Whole', count: 2, weight:'5kg', code:'batchid', bb_date:'01/09/2025');
#PicksheetItem.create(picksheet:saleone.id, product: 'Vintage', size: '1/4', count: 4, weight:'2kg', code:'batchid', bb_date:'11/10/2025');
#PicksheetItem.create(picksheet:saletwo, product: 'Poacher', size: 'Whole', count: 12, weight:'140kg', code:'batchid', bb_date:'01/09/2025');
#PicksheetItem.create(picksheet:saletwo, product: 'Vintage', size: '1/2', count: 2, weight:'20kg', code:'batchid', bb_date:'11/10/2025');
#PicksheetItem.create(picksheet:saletwo, product: 'Poacher', size: '1/4', count: 6, weight:'15kg', code:'batchid', bb_date:'11/10/2025');
#PicksheetItem.create(picksheet:salethree, product: 'Poacher', size: '1/2', count: 2, weight:'20kg', code:'batchid', bb_date:'11/10/2025');
#PicksheetItem.create(picksheet:salethree, product: 'Vintage', size: '1/4', count: 6, weight:'15kg', code:'batchid', bb_date:'11/10/2025');
#PicksheetItem.create(picksheet:salefour, product: 'Poacher', size: 'Whole', count: 2, weight:'5kg', code:'batchid', bb_date:'01/09/2025');
#PicksheetItem.create(picksheet:salefour, product: 'Vintage', size: '1/4', count: 4, weight:'2kg', code:'batchid', bb_date:'11/10/2025');
#PicksheetItem.create(picksheet:salefive, product: 'Poacher', size: 'Whole', count: 12, weight:'140kg', code:'batchid', bb_date:'01/09/2025');
#PicksheetItem.create(picksheet:salefive, product: 'Vintage', size: '1/2', count: 2, weight:'20kg', code:'batchid', bb_date:'11/10/2025');
#PicksheetItem.create(picksheet:salefive, product: 'Poacher', size: '1/4', count: 6, weight:'15kg', code:'batchid', bb_date:'11/10/2025');
#PicksheetItem.create(picksheet:salesix, product: 'Poacher', size: '1/2', count: 2, weight:'20kg', code:'batchid', bb_date:'11/10/2025');
#PicksheetItem.create(picksheet:salesix, product: 'Vintage', size: '1/4', count: 6, weight:'15kg', code:'batchid', bb_date:'11/10/2025');
#poacher = Makesheet.create(status:'Store', make_date:'01/06/2023', make_type: 'Normal', milk_used:5750, total_weight:628.5, number_of_cheeses:31, grade:'Poacher', weight_type: "20kg", batch:  '01-06-29');
#vintage = Makesheet.create(status:'Store', make_date:'02/06/2023', make_type: 'Normal', milk_used:5841, total_weight:543, number_of_cheeses:28, grade:'Vintage', weight_type: "20kg", batch:  '02-06-29');
#p50 = Makesheet.create(status:'Store', make_date:'03/06/2023', make_type: 'Normal', milk_used:5840, total_weight:542, number_of_cheeses:28, grade:'P50', weight_type: "20kg", batch:  '03-06-29');
# Turn.create(turn_date:'01/08/2024', turned_by:'Florence', makesheet:poacher);
# Turn.create(turn_date:'01/08/2024', turned_by:'Florence', makesheet:vintage);
# Turn.create(turn_date:'01/08/2024', turned_by:'Florence', makesheet:p50);
# Turn.create(turn_date:'01/07/2024', turned_by:'Florence', makesheet:poacher);
# Turn.create(turn_date:'01/07/2024', turned_by:'Florence', makesheet:vintage);
# Turn.create(turn_date:'02/07/2024', turned_by:'Florence', makesheet:p50);
# Turn.create(turn_date:'01/06/2024', turned_by:'Florence', makesheet:poacher);
# Turn.create(turn_date:'03/06/2024', turned_by:'Hand', makesheet:vintage);
# Turn.create(turn_date:'01/06/2024', turned_by:'Florence', makesheet:p50);
# Turn.create(turn_date:'01/05/2024', turned_by:'Florence', makesheet:poacher);
# Turn.create(turn_date:'01/04/2024', turned_by:'Florence', makesheet:poacher);
# Turn.create(turn_date:'02/03/2024', turned_by:'Florence', makesheet:poacher);
# Turn.create(turn_date:'03/02/2024', turned_by:'Florence', makesheet:poacher);
# Turn.create(turn_date:'01/01/2024', turned_by:'Florence', makesheet:poacher);
# Turn.create(turn_date:'10/12/2023', turned_by:'Florence', makesheet:poacher);
# Turn.create(turn_date:'14/11/2023', turned_by:'Florence', makesheet:poacher);
# Turn.create(turn_date:'01/10/2023', turned_by:'Florence', makesheet:poacher);
# Turn.create(turn_date:'02/09/2023', turned_by:'Florence', makesheet:poacher);
# Turn.create(turn_date:'03/08/2023', turned_by:'Florence', makesheet:poacher);
# Turn.create(turn_date:'14/07/2023', turned_by:'Florence', makesheet:poacher);
# Turn.create(turn_date:'14/06/2023', turned_by:'Florence', makesheet:poacher);
# Turn.create(turn_date:'04/05/2023', turned_by:'Florence', makesheet:poacher);
# Turn.create(turn_date:'09/04/2023', turned_by:'Florence', makesheet:poacher);
# Turn.create(turn_date:'11/03/2023', turned_by:'Florence', makesheet:poacher);
# Turn.create(turn_date:'01/05/2024', turned_by:'Florence', makesheet:p50);
# Turn.create(turn_date:'01/04/2024', turned_by:'Florence', makesheet:p50);
# Turn.create(turn_date:'02/03/2024', turned_by:'Florence', makesheet:p50);
# Turn.create(turn_date:'03/02/2024', turned_by:'Florence', makesheet:p50);
# Turn.create(turn_date:'01/01/2024', turned_by:'Florence', makesheet:p50);
# Turn.create(turn_date:'10/12/2023', turned_by:'Florence', makesheet:p50);
# Turn.create(turn_date:'14/11/2023', turned_by:'Florence', makesheet:p50);
# Turn.create(turn_date:'01/10/2023', turned_by:'Florence', makesheet:p50);
# Turn.create(turn_date:'02/09/2023', turned_by:'Hand', makesheet:p50);
# Turn.create(turn_date:'03/08/2023', turned_by:'Florence', makesheet:p50);
# Turn.create(turn_date:'14/07/2023', turned_by:'Florence', makesheet:p50);
# Turn.create(turn_date:'14/06/2023', turned_by:'Florence', makesheet:p50);
# Turn.create(turn_date:'04/05/2023', turned_by:'Florence', makesheet:p50);
# Turn.create(turn_date:'09/04/2023', turned_by:'Florence', makesheet:p50);
# Turn.create(turn_date:'11/03/2023', turned_by:'Florence', makesheet:p50);


#jon = Staff.create(employment_status:'Active', first_name:'Jon', last_name:'Collins', dept:'Cheesemaking Team', role:'Head Cheesemaker', created_at:'2024-10-29 07:56:59.324996', updated_at:'2024-10-29 07:56:59.324996');
#PalletisedDistribution.create(date: '01/01/2025', company_name:'Langdons', registration:'WU73GVD', trailer_number_type:'Arctic', temperature:2, vehicle_clean:'true', destination:'H&B',number_of_pallets:1, staff_id: jon );
#PalletisedDistribution.create(date: '01/05/2025', company_name:'Langdons', registration:'WU85KGN', trailer_number_type:'Arctic', temperature:2, vehicle_clean:'true', destination:'Arkwrights',number_of_pallets:2, staff_id: jon );

puts "🌱 Base seed completed."
