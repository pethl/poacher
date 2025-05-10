require 'rails_helper'
passed_pages = []

RSpec.feature "PageSmoke", type: :feature do
  scenario "admin user loads all critical pages and displays correct headings" do
    admin = create(:user, role: :admin)
    login_as(admin, scope: :user)

   
    pages = [
      { path: -> { root_path } },

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
      { path: -> { milk_quality_monitors_path }, page_title: "MILK QUALITY MONITOR" },
      { path: -> { rolling_geo_average_milk_quality_monitors_path }, page_title: "ROLLING GEO AVERAGE" },
      { path: -> { batch_weights_path }, page_title: "CHEESE BATCH WEIGHTS" },
      { path: -> { breakages_path }, page_title: "BREAKAGES" },
      { path: -> { chillers_path }, page_title: "CHILLER TEMPERATURE DISPLAY" },
      { path: -> { butter_makes_path }, page_title: "BUTTER MAKE SCHEDULE" },
      #{ path: -> { waste_records_path }, page_title: "WASTE RECORDS" },

      { path: -> { traceability_records_path }, page_title: "BATCH INDIVIDUAL TRACEABILITY" },
      { path: -> { butter_stocks_path }, page_title: "BUTTER STOCK" },
      { path: -> { samples_path }, page_title: "SAMPLES" },
      { path: -> { staffs_path }, page_title: "STAFF" },
      { path: -> { contacts_path }, page_title: "CUSTOMERS" },

      { path: -> { calculations_path }, page_title: "CALCULATIONS" },
      { path: -> { references_path }, page_title: "REFERENCE DATA" },
      #{ path: -> { wash_picksheets_path }, page_title: "WASH PICKSHEETS" },
      { path: -> { washes_path }, page_title: "WASH LISTS" },

      { path: -> { makesheets_path }, page_title: "MAKESHEETS" },
      #{ path: -> { -> { makesheets_yield_dashboard_path } }, page_title: "YIELD DASHBOARD" },
      { path: -> { makesheets_monthly_summary_path }, page_title: "MONTHLY SUMMARY" },
      { path: -> { makesheets_graded_blackboard_path }, page_title: "GRADED BLACKBOARD" },

      { path: -> { turns_path }, page_title: "TURNS" },

      { path: -> { picksheets_path }, page_title: "PICKING SHEETS" },
      { path: -> { open_picksheets_picksheets_path }, page_title: "OPEN PICKING SHEETS" },
      { path: -> { assigned_picksheets_picksheets_path }, page_title: "ASSIGNED PICKING SHEETS" },
      { path: -> { cutting_picksheets_picksheets_path }, page_title: "CUTTING PICKING SHEETS" },
      { path: -> { shipped_picksheets_picksheets_path }, page_title: "SHIPPED PICKING SHEETS" },
      { path: -> { dispatch_and_collection_picksheets_path }, page_title: "DISPATCH AND COLLECTIONS" },

      { path: -> { users_path }, page_title: "USERS" }
    ]

 

    aggregate_failures("All critical pages display the expected page titles") do
      pages.each do |page_info|
        path = page_info[:path].call
        visit path
    
        if page_info[:page_title].present?
          expect(page).to have_content(page_info[:page_title]), "Expected to find '#{page_info[:page_title]}' on #{path}"
          passed_pages << page_info[:page_title]
          puts "\e[32m✅ Page '#{page_info[:page_title]}' loaded successfully at #{path}\e[0m"
        else
          puts "\e[33m⚠️ No page title defined for #{path} — skipping title check\e[0m"
        end
      end
    end
    puts "\n🎉 Smoke test passed for #{passed_pages.count} critical pages!"
  end
end
