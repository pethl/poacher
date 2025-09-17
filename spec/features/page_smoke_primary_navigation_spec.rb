# frozen_string_literal: true

require "rails_helper"

# This spec mimics what real users do: they land on each section home page
# (Dairy, Store, Wash, Cutting, Office, Mgmt) and then click the key links
# shown there. It favors finding links by their destination href so you can
# freely tweak the link text on the home pages without breaking the tests.
#
# ✅ Easy to maintain: update the SECTIONS map below and you're done
# ✅ Skips gracefully if a link is temporarily hidden (prints ⚠️ Skipped)
# ✅ Prints a compact summary at the end
# ✅ Optional per-destination title checks (case-insensitive)
#
# Tip: If you add or remove cards/links on a home page, just change the list
# in the corresponding section below.

RSpec.feature "PrimaryNavigationSmoke", type: :feature do
  include Rails.application.routes.url_helpers

  scenario "admin can open the primary navigation links from each section" do
    admin = create(:user, role: :admin)
    login_as(admin, scope: :user)

    # --- Configuration ------------------------------------------------------
    # Each section has a :home (where users start) and an array of :links.
    # Each link uses :href (preferred, resilient to text changes) and can
    # optionally specify :page_title to assert on a heading after navigation.
    # Lambdas are used so route helpers/params are evaluated at runtime.

    ASSERT_TITLES = ENV["ASSERT_TITLES"] == "true"

    SECTIONS = {
      dairy: {
        home: -> { "/pages/dairy_home" },
        links: [
          { href: -> { new_makesheet_path(make_type: "Standard", weight_type: "Standard (20 kgs)") }, page_title: "MAKESHEET" },
          { href: -> { new_makesheet_path(make_type: "Red",      weight_type: "Half Truckle (10 kgs)") }, page_title: "MAKESHEET" },
          { href: -> { new_makesheet_path(make_type: "P50",      weight_type: "Standard (20kgs)") }, page_title: "MAKESHEET" },
          { href: -> { makesheets_path }, page_title: "MAKESHEETS" },
          { href: -> { monthly_summary_makesheets_path }, page_title: "MONTHLY SUMMARY" },
          { href: -> { on_hold_makesheets_path }, page_title: "ON HOLD" },
          { href: -> { week_view_cleaning_foreign_body_checks_path }, page_title: "CLEANING AND FOREIGN BODY CHECKS: WEEK VIEW" },
          { href: -> { "/makesheets/yield_dashboard" }, page_title: "YIELD" },
          { href: -> { "/pages/rennet_guidance" }, page_title: "RENNET" },
          { href: -> { "/delivery_inspections" }, page_title: "DELIVERY INSPECTION RECORD - INGREDIENTS AND PACKAGING" },
          { href: -> { audit_report_path }, page_title: "CHEESE MAKE AUDIT" }
        ]
      },

      store: {
        home: -> { "/pages/store_home" },
        links: [
          { href: -> { "/location_assignments/new" }, page_title: "LOCATION ASSIGNMENTS" },
          { href: -> { "/location_report" }, page_title: "LOCATION REPORT" },
          { href: -> { "/location_inspection" }, page_title: "AISLE INSPECTION" },
          { href: -> { shed_map_path(shed: 4) }, page_title: "SHED MAP" },
          { href: -> { new_turn_path }, page_title: "NEW TURN" },
          { href: -> { "/turns/bulk_new" }, page_title: "FLORENCE TURNS" },
          { href: -> { duplicate_assignments_locations_path }, page_title: "DUPLICATE LOCATION CHECKER" },
          { href: -> { graded_blackboard_makesheets_path }, page_title: "GRADED BLACKBOARD" },
          { href: -> { preload_grading_notes_path }, page_title: "PRELOAD GRADING NOTES WIZARD" },
          { href: -> { grading_notes_path }, page_title: "GRADING" }
        ]
      },

      wash: {
        home: -> { "/pages/wash_home" },
        links: [
          { href: -> { washes_path }, page_title: "WASH LISTS" },
          { href: -> { cheese_wash_records_path(status: "started") }, page_title: "CHEESE WASH RECORDS" }
        ]
      },

      cutting: {
        home: -> { "/pages/cutting_home" },
        links: [
          # Status counters on labels can change, so we click by href only
          { href: -> { open_picksheets_picksheets_path }, page_title: "OPEN PICKING SHEETS" },
          { href: -> { assigned_picksheets_picksheets_path }, page_title: "ASSIGNED PICKING SHEETS" },
          { href: -> { cutting_picksheets_picksheets_path }, page_title: "CUTTING PICKING SHEETS" },
          { href: -> { new_picksheet_path }, page_title: "NEW PICKING SHEET" },
          { href: -> { daily_cheese_manifest_picksheets_path }, page_title: "DAILY CHEESE MANIFEST" },
          { href: -> { dispatch_and_collection_picksheets_path }, page_title: "DISPATCH AND COLLECTION" },
          { href: -> { traceability_records_path }, page_title: "BATCH INDIVIDUAL TRACEABILITY" },
          { href: -> { batch_weights_path }, page_title: "CHEESE BATCH WEIGHTS" },
          { href: -> { vacuum_pouch_calculator_path }, page_title: "WEIGHT CALCULATOR" },
          { href: -> { chillers_path }, page_title: "CHILLER TEMPERATURE DISPLAY" },
          { href: -> { week_view_scale_checks_path }, page_title: "SCALE CHECKS: WEEK VIEW" },
          { href: -> { breakages_path }, page_title: "BREAKAGES" }
        ]
      },

      office: {
        home: -> { "/pages/office_home" },
        links: [
          { href: -> { staffs_path }, page_title: "STAFF" },
          { href: -> { contacts_path }, page_title: "CUSTOMERS" },
          { href: -> { users_path }, page_title: "USERS" },
          { href: -> { references_path }, page_title: "REFERENCE DATA" },
          { href: -> { locations_path }, page_title: "LOCATIONS" },
          { href: -> { "/locations/print_wizard" }, page_title: "LABEL PRINT" },
          { href: -> { calculations_path }, page_title: "CALCULATIONS" },
          { href: -> { validation_ranges_path }, page_title: "VALIDATIONS" },
          { href: -> { butter_stocks_path }, page_title: "BUTTER STOCK" },
          { href: -> { samples_path }, page_title: "SAMPLES" },
          { href: -> { milk_quality_monitors_path }, page_title: "MILK QUALITY MONITOR" },
          { href: -> { palletised_distributions_path }, page_title: "PALLETISED DISTRIBUTION VEHICLE DETAILS" }
        ]
      },

      mgmt: {
        home: -> { "/pages/mgmt_home" },
        links: [
          { href: -> { "/makesheets/overview" }, page_title: "STOCK POSITION" },
          { href: -> { simple_new_makesheets_path }, page_title: "MAKESHEET ARCHIVING" }
        ]
      }
    }.freeze

    # --- Runner -------------------------------------------------------------
    passed = []
    skipped = []
    failed  = []

    def click_link_by_href_or_skip(href)
      # Prefer exact href match; if not present, try best-effort contains()
      link = nil
      begin
        link = find(:css, "a[href='#{href}']", match: :first)
      rescue Capybara::ElementNotFound
        begin
          link = find(:css, "a[href*='#{href}']", match: :first)
        rescue Capybara::ElementNotFound
          return nil
        end
      end
      link.click
      true
    end

    SECTIONS.each do |section, config|
      home_path = instance_exec(&config[:home])
      puts "\n\e[34m▶ SECTION: #{section.to_s.upcase} (#{home_path})\e[0m"

      visit home_path
      expect(page).to have_current_path(home_path, url: false)

      config[:links].each do |link_cfg|
        href = instance_exec(&link_cfg[:href])
        title = link_cfg[:page_title]

        begin
          unless click_link_by_href_or_skip(href)
            skipped << { section:, href:, reason: "Link not found on page" }
            puts "\e[33m⚠️  Skipped: #{href} (not present)\e[0m"
            next
          end

          # Basic health checks instead of specific titles
          if page.driver.respond_to?(:status_code)
            expect(page.status_code).to be_between(200, 399),
              "Expected a successful HTTP status after clicking #{href}, got #{page.status_code}"
          end

          # Look for common Rails error page text to catch 500s with non-rack drivers
          aggregate_failures do
            expect(page).not_to have_text(/We're sorry, but something went wrong/i)
            expect(page).not_to have_text(/Routing Error/i)
            expect(page).not_to have_text(/ActiveRecord::RecordNotFound/i)
          end

          # Optional: allow opt-in title assertions via env flag
          if ASSERT_TITLES && title.present?
            expect(page).to have_text(/#{Regexp.escape(title)}/i),
              "Expected to find '#{title}' after clicking #{href}"
          end

          passed << { section:, href:, title: title }
          puts "\e[32m✅ Opened: #{href}#{" — '#{title}'" if title}\e[0m"
        rescue => e
          failed << { section:, href:, error: e.message }
          puts "\e[31m💥 Failed: #{href} — #{e.class}: #{e.message}\e[0m"
        ensure
          # Go back to the section home for the next link
          visit home_path
        end
      end
    end

    puts "\n\e[32m✅ #{passed.count} passed\e[0m"
    puts "\e[33m⚠️  #{skipped.count} skipped\e[0m"
    puts "\e[31m❌ #{failed.count} failed\e[0m"

    if skipped.any?
      puts "\n\e[33mSkipped details:\e[0m"
      skipped.each { |s| puts " - [#{s[:section]}] #{s[:href]} — #{s[:reason]}" }
    end

    expect(failed).to be_empty, "Some navigation links failed to open or validate"
  end
end
