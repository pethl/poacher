class AddCreatedByAndUpdatedByToModels < ActiveRecord::Migration[7.1]

  def change
    %w[
      batch_weights breakages butter_makes butter_stocks calculations
      cheese_wash_records chillers cleaning_foreign_body_checks contacts
      grading_notes invoices locations makesheets market_sales
      milk_quality_monitors palletised_distributions picksheet_items
      picksheets samples scale_checks traceability_records turns
      washes waste_records references staffs
    ].each do |table|
      add_reference table.to_sym, :created_by, foreign_key: { to_table: :users }, index: true
      add_reference table.to_sym, :updated_by, foreign_key: { to_table: :users }, index: true
    end
  end
  end
  