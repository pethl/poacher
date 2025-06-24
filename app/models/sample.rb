class Sample < ApplicationRecord
  has_and_belongs_to_many :makesheets
  validates :sample_no, uniqueness: true

  scope :ordered, -> { order(sample_no: :asc) }

  def self.import(upload)
    upload = upload.first if upload.is_a?(Array)
    ext = File.extname(upload.original_filename).downcase

    case ext
    when ".csv"
      import_csv(upload)
    when ".xlsx", ".xls"
      import_excel(upload)
    else
      raise "Unsupported file type: #{upload.original_filename}"
    end
  end

  def self.import_csv(upload)
    csv = CSV.read(upload.path, headers: true)
    csv.each do |row|
      Sample.find_or_create_by!(sample_no: row['Sample No.']) do |s|
        assign_sample_attributes(s, row)
      end
    end
    { imported_count: csv.size, rejected_count: 0 }
  end

  def self.import_excel(upload)
    sheet = Roo::Spreadsheet.open(upload.path).sheet(0)
    header = sheet.row(1)
    imported_count = 0

    (2..sheet.last_row).each do |i|
      row = Hash[[header, sheet.row(i)].transpose]
      Sample.find_or_create_by!(sample_no: row['Sample No.']) do |s|
        assign_sample_attributes(s, row)
      end
      imported_count += 1
    end

    { imported_count: imported_count, rejected_count: 0 }
  end

  def self.assign_sample_attributes(sample, row)
    sample.sample_description = row['Sample Description']
    sample.received_date = row['Received']
    sample.suite = row['Suite']
    sample.classification = row['Classification']
    sample.schedule = row['Schedule']
    sample.barcode_count = row['Barcode Count']
    sample.coagulase_positive_staphylococcus_37c_umqv9 = row['Coagulase positive Staphylococcus 37°C (UMQV9) (cfu/g)']
    sample.coagulase_positive_staphylococcus_37c_umqzw = row['Coagulase positive Staphylococcus 37°C (UMQZW) (cfu/g)']
    sample.escherichia_coli_b_glucuronidase = row['Escherichia coli B-Glucuronidase+ (cfu/g)']
    sample.listeria_species = row['Listeria Species (/25 g)']
    sample.listeria_species_37 = row['Listeria species 37°C (cfu/g)']
    sample.presumptive_coliforms = row['Presumptive Coliforms 37°C (cfu/g)']
    sample.salmonella = row['Salmonella (/25 g)']
    sample.staphylococcus_aureus_enterotoxins = row['Staphylococcus aureus enterotoxins (/10  g)']
    sample.aerobic_plate_count_22c_3_days = row['Aerobic Plate Count 22°C [3 days] (cfu/ml)']
    sample.aerobic_plate_count_30c = row['Aerobic Plate Count 30°C (cfu/g)']
    sample.aerobic_plate_count_37c_2_days = row['Aerobic Plate Count 37°C [2 days] (cfu/ml)']
    sample.ash = row['Ash (g/100 g)']
    sample.campylobacter_species_10g = row['Campylobacter Species (/10  g)']
    sample.campylobacter_species_25g = row['Campylobacter Species (/25 g)']
    sample.carbohydrates = row['Carbohydrates (available) (g/100 g)']
    sample.crude_protein = row['Crude Protein (Nx6.25) (Dumas) (g/100 g)']
    sample.energy_kcal = row['Energy value (kcal) (kcal/100 g)']
    sample.energy_kj = row['Energy value (kJ) (kJ/100 g)']
    sample.escherichia_coli_100ml = row['Escherichia coli (cfu/100 ml)']
    sample.escherichia_coli_o157 = row['Escherichia Coli O157 (/25 g)']
    sample.fructose = row['Fructose (g/100 g)']
    sample.galactose = row['Galactose (g/100 g)']
    sample.glucose = row['Glucose (g/100 g)']
    sample.histamine = row['Histamine (mg/kg)']
    sample.identification_listeria_species_1 = row['Identification Listeria species 1 (/)']
    sample.lactose = row['Lactose (g/100 g)']
    sample.listeria_species_swab = row['Listeria Species (/Swab)']
    sample.listeria_species_confirmation_maldi = row['Listeria species Confirmation (MALDI-TOF) (/Swab)']
    sample.maltose = row['Maltose (g/100 g)']
    sample.moisture = row['Moisture (g/100 g)']
    sample.monounsaturated_fatty_acids = row['Monounsaturated fatty acids (g/100 g)']
    sample.ph = row['pH (/)']
    sample.polyunsaturated_fatty_acids = row['Polyunsaturated fatty acids (g/100 g)']
    sample.presumptive_coliforms_swab = row['Presumptive Coliforms 37°C (cfu/Swab)']
    sample.presumptive_enterobacteriaceae = row['Presumptive Enterobacteriaceae 37°C (cfu/g)']
    sample.salt = row['Salt (via sodium x 2.5) (g/100 g)']
    sample.saturated_fatty_acids = row['Saturated fatty acids (g/100 g)']
    sample.sodium = row['Sodium (g/100 g)']
    sample.sucrose = row['Sucrose (g/100 g)']
    sample.total_coliforms_100ml = row['Total Coliforms (cfu/100 ml)']
    sample.total_dietary_fibre = row['Total Dietary Fibre (AOAC 991.43) (g/100 g)']
    sample.total_fat = row['Total Fat (g/100 g)']
    sample.total_sugars = row['Total sugars (g/100 g)']
    sample.trans_fatty_acids_per_fat = row['Trans fatty acids (g/100 g fat)']
    sample.trans_fatty_acids = row['Trans Fatty Acids (g/100 g)']
    sample.water_activity = row['Water activity (/)']
  end
end

 