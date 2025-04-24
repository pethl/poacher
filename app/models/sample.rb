class Sample < ApplicationRecord
  has_and_belongs_to_many :makesheets
  validates :sample_no, uniqueness: true  

  scope :ordered, -> { order(sample_no: :asc) }

  def self.import(file)
    case File.extname(file.original_filename).downcase
    when ".csv"
      return import_csv(file)
    when ".xlsx", ".xls"
      return import_excel(file)
    else
      raise "Unknown file type: #{file.original_filename}"
    end
  end

  def self.import_csv(file)
    imported_count = 0
    rejected_count = 0
    rejected_samples = []
  
    csv_data = CSV.read(file.path, headers: true, encoding: 'bom|utf-8')
  
    existing_sample_nos = Sample.pluck(:sample_no).to_set
    new_samples = []
  
    csv_data.each do |row|
      sample_no = row['Sample No.']
  
      # Skip if duplicate
      if existing_sample_nos.include?(sample_no)
        rejected_count += 1
        rejected_samples << sample_no
        next
      end
  
      # Optional: format sample_description
      if row['Sample Description'].present?
        row['Sample Description'] = row['Sample Description'].sub(' - ', '<br>')
      end
  
      # Build Sample object (use symbol keys if your model expects that)
      new_samples << Sample.new(
        sample_no: sample_no,
        received_date: row['Received'],
        sample_description: row['Sample Description'],
        suite: row['Suite'],
        classification: row['Classification'],
        schedule: row['Schedule'],
        barcode_count: row['Barcode Count'],
        coagulase_positive_staphylococcus_37c_umqv9: row['Coagulase positive Staphylococcus 37°C (UMQV9) (cfu/g)'],
        coagulase_positive_staphylococcus_37c_umqzw: row['Coagulase positive Staphylococcus 37°C (UMQZW) (cfu/g)'],
        escherichia_coli_b_glucuronidase: row['Escherichia coli B-Glucuronidase+ (cfu/g)'],
        listeria_species: row['Listeria Species (/25 g)'],
        listeria_species_37: row['Listeria species 37°C (cfu/g)'],
        presumptive_coliforms: row['Presumptive Coliforms 37°C (cfu/g)'],
        salmonella: row['Salmonella (/25 g)'],
        staphylococcus_aureus_enterotoxins: row['Staphylococcus aureus enterotoxins (/10  g)']
      )
  
      imported_count += 1
    end
  
    # 🚀 Bulk insert
    Sample.import(new_samples) if new_samples.any?
  
    { imported_count: imported_count, rejected_count: rejected_count, rejected_samples: rejected_samples }
  end

  def self.import_excel(file)
    imported_count = 0
    rejected_count = 0
    rejected_samples = []
  
    xlsx = Roo::Spreadsheet.open(file.path)
    sheet = xlsx.sheet(0)
  
    existing_sample_nos = Sample.pluck(:sample_no).to_set
    new_samples = []
  
    sheet.each_with_index(
      sample_no: 'Sample No.',
      received_date: 'Received',
      sample_description: 'Sample Description',
      suite: 'Suite',
      classification: 'Classification',
      schedule: 'Schedule',
      barcode_count: 'Barcode Count',
      coagulase_positive_staphylococcus_37c_umqv9: 'Coagulase positive Staphylococcus 37°C (UMQV9) (cfu/g)',
      coagulase_positive_staphylococcus_37c_umqzw: 'Coagulase positive Staphylococcus 37°C (UMQZW) (cfu/g)',
      escherichia_coli_b_glucuronidase: 'Escherichia coli B-Glucuronidase+ (cfu/g)',
      listeria_species: 'Listeria Species (/25 g)',
      listeria_species_37: 'Listeria species 37°C (cfu/g)',
      presumptive_coliforms: 'Presumptive Coliforms 37°C (cfu/g)',
      salmonella: 'Salmonella (/25 g)',
      staphylococcus_aureus_enterotoxins: 'Staphylococcus aureus enterotoxins (/10  g)'
    ) do |row, index|
      next if index == 0  # Skip header row
  
      if existing_sample_nos.include?(row[:sample_no])
        rejected_count += 1
        rejected_samples << row[:sample_no]
        next
      end
  
      if row[:sample_description].present?
        row[:sample_description] = row[:sample_description].sub(' - ', '<br>')
      end
  
      new_samples << Sample.new(row)
      imported_count += 1
    end
  
    Sample.import!(new_samples) if new_samples.any?

    Rails.logger.debug "Inside import_excel, returning import summary"
  
    { imported_count: imported_count, rejected_count: rejected_count, rejected_samples: rejected_samples }
  end
  
  

end
 