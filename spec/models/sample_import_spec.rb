# frozen_string_literal: true

require 'rails_helper'
require 'tempfile'

RSpec.describe Sample, type: :model do
  describe '.import (CSV)' do
    it 'creates records and does not duplicate existing sample numbers' do
      csv = nil

      csv = Tempfile.new(['samples', '.csv'])
      csv.write(<<~CSV)
        Sample No.,Sample Description,Received,Suite,Classification,Schedule,Barcode Count
        A001,Cheddar,2025-01-01,Suite1,Class1,Sch1,1
        A002,Blue,2025-01-02,Suite1,Class1,Sch1,1
      CSV
      csv.flush

      upload = double(
        'Upload',
        original_filename: File.basename(csv.path),
        path: csv.path
      )

      first_result = described_class.import([upload])
      second_result = described_class.import(upload)

      expect(described_class.count).to eq(2)
      expect(described_class.pluck(:sample_no))
        .to contain_exactly('A001', 'A002')

      expect(first_result).to eq(
        imported_count: 2,
        rejected_count: 0
      )

      # This is the current importer behaviour.
      # Duplicate records are not created, but are still counted as imported.
      expect(second_result).to eq(
        imported_count: 2,
        rejected_count: 0
      )
    ensure
      csv&.close!
    end
  end

  describe '.import (XLSX)' do
    it 'imports spreadsheet rows through Roo' do
      xlsx = nil

      xlsx = Tempfile.new(['samples', '.xlsx'])

      upload = double(
        'Upload',
        original_filename: File.basename(xlsx.path),
        path: xlsx.path
      )

      fake_sheet = double('Roo::Sheet')

      allow(fake_sheet).to receive(:row) do |row_number|
        row_number == 1 \
          ? ['Sample No.', 'Sample Description'] \
          : ['B009', 'Brie']
      end

      allow(fake_sheet).to receive(:last_row).and_return(2)

      fake_book = double(
        'Roo::Spreadsheet',
        sheet: fake_sheet
      )

      allow(Roo::Spreadsheet)
        .to receive(:open)
        .with(xlsx.path)
        .and_return(fake_book)

      expect {
        described_class.import(upload)
      }.to change(described_class, :count).by(1)

      expect(
        described_class.find_by(sample_no: 'B009')&.sample_description
      ).to eq('Brie')
    ensure
      xlsx&.close!
    end
  end

  describe '.import (unsupported)' do
    it 'raises an error for an unsupported file extension' do
      file = nil

      file = Tempfile.new(['samples', '.pdf'])

      upload = double(
        'Upload',
        original_filename: File.basename(file.path),
        path: file.path
      )

      expect {
        described_class.import(upload)
      }.to raise_error(/Unsupported file type/)
    ensure
      file&.close!
    end
  end
end