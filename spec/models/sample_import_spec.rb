# frozen_string_literal: true
require 'rails_helper'
require 'tempfile'

RSpec.describe Sample, type: :model do
  describe '.import (CSV)' do
    it 'creates records and is idempotent on sample_no' do
      csv = Tempfile.new(['samples', '.csv'])
      csv.write(<<~CSV)
        Sample No.,Sample Description,Received,Suite,Classification,Schedule,Barcode Count
        A001,Cheddar,2025-01-01,Suite1,Class1,Sch1,1
        A002,Blue,2025-01-02,Suite1,Class1,Sch1,1
      CSV
      csv.flush

      upload = double('Upload',
      original_filename: File.basename(csv.path),
      path: csv.path
    )

      result1 = Sample.import([upload])
      result2 = Sample.import(upload) # either array or single works

      expect(Sample.count).to eq(2)
      expect(Sample.pluck(:sample_no)).to contain_exactly('A001', 'A002')
      expect(result1).to eq(imported_count: 2, rejected_count: 0)
      expect(result2).to eq(imported_count: 2, rejected_count: 0) # re-import doesn’t add duplicates (find_or_create_by!)
    ensure
      csv.close!
    end
  end

 # spec/models/sample_import_spec.rb (XLSX)
describe '.import (XLSX)' do
  it 'routes to import_excel via Roo' do
    xlsx = Tempfile.new(['samples', '.xlsx'])
    upload = double('Upload',
      original_filename: File.basename(xlsx.path),
      path: xlsx.path
    )

    fake_sheet = double('Roo::Sheet')
    allow(fake_sheet).to receive(:row) do |i|
      i == 1 ? ['Sample No.', 'Sample Description'] : ['B009', 'Brie']
    end
    allow(fake_sheet).to receive(:last_row).and_return(2)

    fake_book = double('Roo::Spreadsheet', sheet: fake_sheet)
    allow(Roo::Spreadsheet).to receive(:open).with(xlsx.path).and_return(fake_book)

    expect { Sample.import(upload) }.to change { Sample.count }.by(1)
    expect(Sample.find_by(sample_no: 'B009')&.sample_description).to eq('Brie')
  ensure
    xlsx.close!
  end
end


 # spec/models/sample_import_spec.rb (unsupported)
describe '.import (unsupported)' do
  it 'raises for unknown extension' do
    tmp = Tempfile.new(['samples', '.pdf'])
    upload = double('Upload',
      original_filename: File.basename(tmp.path),
      path: tmp.path
    )

    expect { Sample.import(upload) }.to raise_error(/Unsupported file type/)
  ensure
    tmp.close!
  end
end

end

