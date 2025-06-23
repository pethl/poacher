require "rails_helper"
RSpec.feature "PageSmoke", type: :feature do
  scenario "admin user loads all critical pages and displays correct headings" do
    admin = create(:user, role: :admin)
    login_as(admin, scope: :user)

    passed_pages = []
    skipped_pages = []
    failed_pages = []

    pages = [
      { path: -> { root_path } },
      { path: -> { "/pages/home" } },
      { path: -> { "/pages/dairy_home" }, page_title: "DAIRY" },
      { path: -> { "/pages/store_home" }, page_title: "STORE" },
      { path: -> { "/pages/wash_home" }, page_title: "WASH" },
      { path: -> { "/pages/cutting_home" }, page_title: "CUTTING" },
      { path: -> { "/pages/office_home" }, page_title: "OFFICE" },
      { path: -> { "/pages/mgmt_home" }, page_title: "MANAGEMENT" },
      { path: -> { "/pages/credits" }, page_title: "CREDITS" },
      { path: -> { vacuum_pouch_calculator_path }, page_title: "WEIGHT CALCULATOR" },
      { path: -> { cleaning_foreign_body_checks_path }, page_title: "CLEANING AND FOREIGN BODY CHECKS" },
      { path: -> { week_view_cleaning_foreign_body_checks_path }, page_title: "CLEANING AND FOREIGN BODY CHECKS: WEEK VIEW" },
      { path: -> { scale_checks_path }, page_title: "SCALE CHECKS" },
      { path: -> { week_view_scale_checks_path }, page_title: "SCALE CHECKS: WEEK VIEW" },
      { path: -> { grading_notes_path }, page_title: "GRADING" },
      { path: -> { preload_grading_notes_path }, page_title: "PRELOAD GRADING NOTES WIZARD" },
      { path: -> { invoices_path }, page_title: "INVOICES" },
      { path: -> { summary_invoices_path }, page_title: "INVOICES SUMMARY" },
      { path: -> { market_sales_path }, page_title: "MARKET SALES" },
      { path: -> { summary_market_sales_path }, page_title: "MARKET SALES SUMMARY" },
      { path: -> { palletised_distributions_path }, page_title: "PALLETISED DISTRIBUTION VEHICLE DETAILS" },
      { path: -> { batch_weights_path }, page_title: "CHEESE BATCH WEIGHTS" },
      { path: -> { breakages_path }, page_title: "BREAKAGES" },
      { path: -> { chillers_path }, page_title: "CHILLER TEMPERATURE DISPLAY" },
      { path: -> { butter_makes_path }, page_title: "BUTTER MAKE SCHEDULE" },
      { path: -> { milk_quality_monitors_path }, page_title: "MILK QUALITY MONITOR" },
      { path: -> { rolling_geo_average_milk_quality_monitors_path }, page_title: "ROLLING GEO AVERAGE" },
      { path: -> { traceability_records_path }, page_title: "BATCH INDIVIDUAL TRACEABILITY" },
      { path: -> { butter_stocks_path }, page_title: "BUTTER STOCK" },
      { path: -> { samples_path }, page_title: "SAMPLES" },
      { path: -> { staffs_path }, page_title: "STAFF" },
      { path: -> { contacts_path }, page_title: "CUSTOMERS" },
      { path: -> { calculations_path }, page_title: "CALCULATIONS" },
      { path: -> { references_path }, page_title: "REFERENCE DATA" },
      { path: -> { washes_path }, page_title: "WASH LISTS" },
      { path: -> { makesheets_path }, page_title: "MAKESHEETS" },
      { path: -> { monthly_summary_makesheets_path }, page_title: "MONTHLY SUMMARY" },
      { path: -> { graded_blackboard_makesheets_path }, page_title: "GRADED BLACKBOARD" },
      #
      { path: -> { turns_path }, page_title: "TURNS" },
      { path: -> { picksheets_path }, page_title: "PICKING SHEETS" },
      { path: -> { open_picksheets_picksheets_path }, page_title: "OPEN PICKING SHEETS" },
      { path: -> { assigned_picksheets_picksheets_path }, page_title: "ASSIGNED PICKING SHEETS" },
      { path: -> { cutting_picksheets_picksheets_path }, page_title: "CUTTING PICKING SHEETS" },
      { path: -> { shipped_picksheets_picksheets_path }, page_title: "SHIPPED PICKING SHEETS" },
      { path: -> { dispatch_and_collection_picksheets_path }, page_title: "DISPATCH AND COLLECTIONS" },
      { path: -> { daily_cheese_manifest_picksheets_path }, page_title: "DAILY CHEESE MANIFEST" },
      # { path: -> { print_manifest_pdf_picksheets_path }, page_title: "PRINT MANIFEST PDF" },
     # { path: -> { print_dispatch_pdf_picksheets_path }, page_title: "PRINT DISPATCH PDF" },
      { path: -> { users_path }, page_title: "USERS" }
    ]

    pages.each do |page_info|
      begin
        path = page_info[:path].call
        visit path

        if page_info[:page_title].present?
          expect(page.text).to match(/#{Regexp.escape(page_info[:page_title])}/i),
            "Expected to find '#{page_info[:page_title]}' on #{path} (case-insensitive match)"
          passed_pages << page_info[:page_title]
          puts "\e[32m✅ Page '#{page_info[:page_title]}' loaded successfully at #{path}\e[0m"
        else
          puts "\e[33m⚠️ No page title defined for #{path} — skipping title check\e[0m"
        end
      rescue => e
        failed_pages << { path: path, error: e.message }
        puts "\e[31m💥 Error visiting #{path}: #{e.class} - #{e.message}\e[0m"
      end
    end

    puts "\n✅ #{passed_pages.count} passed"
    puts "⚠️  #{skipped_pages.count} skipped"
    puts "❌ #{failed_pages.count} failed"

    expect(failed_pages).to be_empty, "Some pages failed to load or match titles"
  end
end

