# frozen_string_literal: true

require "rails_helper"

# See README in previous messages for intent.
# This version adds:
# - Header-scoped "Add New" (page_button) tester
# - Header-scoped "Print" (print_button) tester
# - End-of-run summary for both

RSpec.feature "PrimaryNavigationSmoke", type: :feature do
  include Rails.application.routes.url_helpers

  scenario "admin can open the primary navigation links from each section" do
    admin = create(:user, role: :admin)
    login_as(admin, scope: :user)

    # --- Configuration ------------------------------------------------------

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
          { href: -> { hold_picksheets_picksheets_path }, page_title: "HOLD PICKING SHEETS" },
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

    # Summary counters
    new_buttons_actionable   = 0
    new_buttons_passed       = 0
    print_buttons_actionable = 0  # only non-browser-print
    print_buttons_passed     = 0
    print_buttons_browser    = 0  # skipped because 'browser-print'

    # --- Helpers ------------------------------------------------------------

    def click_link_by_href_or_skip(href)
      # Prefer exact href match; if not present, try contains()
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

    # Detect if the header has an actionable "Add New" in the left slot
    def page_button_actionable?
      title_bar = "header .h-9"                       # bottom row (title bar)
      left_slot = "#{title_bar} .flex-shrink-0:first-child"
      return false unless page.has_css?(title_bar, wait: 0)
      return false unless page.has_css?(left_slot, wait: 0)
      return false unless page.has_css?("#{left_slot} a", wait: 0)

      within(left_slot) do
        link = first(:css, "a", minimum: 0, wait: 0)
        return false unless link
        text_ok = link.text.to_s.strip.match?(/add new/i)
        href_ok = link[:href].to_s.match?(%r{/new(?:[/?]|$)})
        text_ok || href_ok
      end
    end

    # Click the "Add New" and run health checks (assumes actionable)
    def click_and_check_page_button!
      title_bar = "header .h-9"
      left_slot = "#{title_bar} .flex-shrink-0:first-child"
      within(left_slot) do
        link = find(:css, "a", match: :first, wait: 0)
        dest = link[:href]
        link.click

        if page.driver.respond_to?(:status_code)
          expect(page.status_code).to be_between(200, 399),
            "Expected success HTTP status after clicking #{dest}, got #{page.status_code}"
        end

        aggregate_failures do
          expect(page).not_to have_text(/We're sorry, but something went wrong/i)
          expect(page).not_to have_text(/Routing Error/i)
          expect(page).not_to have_text(/ActiveRecord::RecordNotFound/i)
        end

        reached_new = page.has_current_path?(%r{/new(?:/|\?|$)}, url: true)
        has_form    = page.has_css?("form", wait: 0)
        expect(reached_new || has_form).to be(true),
          "Expected to land on a /new page or see a form after clicking page button"
      end
      puts "   ↳ 🧪 page_button worked (header-scoped)"
    end

    # Returns the Node::Element links in the right slot that are "actionable print" links.
    # Actionable = not browser print, and either:
    #  - href ends with .pdf, or
    #  - text starts with "Print", or
    #  - contains a print icon (i.fa-print)
    def actionable_print_links_in_right_slot
      title_bar  = "header .h-9"
      right_slot = "#{title_bar} .flex-shrink-0:last-child"
      return [] unless page.has_css?(title_bar, wait: 0)
      return [] unless page.has_css?(right_slot, wait: 0)

      within(right_slot) do
        all(:css, "a", minimum: 0, wait: 0).reject { |a|
          a[:onclick].to_s.include?("window.print")
        }.select { |a|
          a[:href].to_s.match?(/\.pdf(?:$|\?)/i) ||
          a.text.to_s.strip.match?(/^Print\b/i) ||
          a.has_css?("i.fa-print", wait: 0)
        }
      end
    end

    # Detect print button presence/type in the right slot
    # Returns :absent, :browser, or :actionable
    def print_button_presence
      title_bar  = "header .h-9"
      right_slot = "#{title_bar} .flex-shrink-0:last-child"
      return :absent unless page.has_css?(title_bar, wait: 0)
      return :absent unless page.has_css?(right_slot, wait: 0)
      return :absent unless page.has_css?("#{right_slot} a", wait: 0)
    
      within(right_slot) do
        # If there is a browser print anywhere, we still may also have actionable links.
        has_browser = page.has_css?("a[onclick*='window.print']", wait: 0)
        actionable  = actionable_print_links_in_right_slot
        return :actionable if actionable.any?
        return :browser if has_browser
      end
    
      :absent
    end

    # Verifies PDF using headers/body/URL — factored so we can call it for each link.
    def expect_pdf_response!
      pdf_detected = false

      if page.respond_to?(:response_headers)
        ct = page.response_headers["Content-Type"].to_s
        pdf_detected ||= ct.match?(/application\/pdf/i)
      end

      begin
        body = page.html.to_s
        pdf_detected ||= body.start_with?("%PDF") || body.include?("%PDF-")
      rescue
      end

      begin
        pdf_detected ||= page.current_url.to_s.match?(/\.pdf(?:$|\?)/i)
      rescue
      end

      expect(pdf_detected).to be(true),
        "Expected a PDF response (content-type, %PDF magic header, or .pdf URL), but couldn't confirm."
    end
    

    # Click the Print link and verify PDF (assumes actionable)
    def click_and_check_all_print_pdfs!
      links = actionable_print_links_in_right_slot
      raise "No actionable print links found" if links.empty?
    
      # Re-find by href each time (elements can go stale after navigation/window switch).
      hrefs = links.map { |l| l[:href].to_s }
    
      hrefs.each_with_index do |href, idx|
        title_bar  = "header .h-9"
        right_slot = "#{title_bar} .flex-shrink-0:last-child"
    
        within(right_slot) do
          link = find(:css, "a[href='#{href}']", match: :first, wait: 0)
    
          # If the driver supports window tracking (e.g., Selenium), capture the new tab.
          new_win = nil
          if respond_to?(:window_opened_by)
            new_win = window_opened_by { link.click }
          else
            link.click
          end
    
          if new_win
            within_window(new_win) do
              if page.driver.respond_to?(:status_code)
                expect(page.status_code).to be_between(200, 399),
                  "Expected success HTTP status after clicking Print (##{idx+1}), got #{page.status_code}"
              end
              expect_pdf_response!
            end
            new_win.close
            switch_to_window(windows.first)
          else
            if page.driver.respond_to?(:status_code)
              expect(page.status_code).to be_between(200, 399),
                "Expected success HTTP status after clicking Print (##{idx+1}), got #{page.status_code}"
            end
            expect_pdf_response!
          end
        end
    
        puts "   ↳ 🧪 print_button ##{idx+1} worked (PDF detected) — #{href}"
      end
    
      hrefs.size
    end

    # --- Main loop ----------------------------------------------------------

    SECTIONS.each do |section, config|
      home_path = instance_exec(&config[:home])
      puts "\n\e[34m▶ SECTION: #{section.to_s.upcase} (#{home_path})\e[0m"

      visit home_path
      expect(page).to have_current_path(home_path, url: false)

      config[:links].each do |link_cfg|
        href  = instance_exec(&link_cfg[:href])
        title = link_cfg[:page_title]

        begin
          unless click_link_by_href_or_skip(href)
            skipped << { section:, href:, reason: "Link not found on page" }
            puts "\e[33m⚠️  Skipped: #{href} (not present)\e[0m"
            next
          end

          # Basic health checks
          if page.driver.respond_to?(:status_code)
            expect(page.status_code).to be_between(200, 399),
              "Expected a successful HTTP status after clicking #{href}, got #{page.status_code}"
          end

          aggregate_failures do
            expect(page).not_to have_text(/We're sorry, but something went wrong/i)
            expect(page).not_to have_text(/Routing Error/i)
            expect(page).not_to have_text(/ActiveRecord::RecordNotFound/i)
          end

          # Optional title assertion
          if ASSERT_TITLES && title.present?
            expect(page).to have_text(/#{Regexp.escape(title)}/i),
              "Expected to find '#{title}' after clicking #{href}"
          end

          # 🔹 Page "Add New" button (header left slot)
          begin
            if page_button_actionable?
              new_buttons_actionable += 1
              click_and_check_page_button!
              new_buttons_passed += 1
            else
              puts "   ↳ (no page_button present)"
            end
          rescue => e
            failed << { section:, href: "#{href} [page_button]", error: e.message }
            puts "\e[31m   ↳ 💥 page_button failed — #{e.class}: #{e.message}\e[0m"
          end

          # 🔹 Print button (header right slot)
          begin
            case print_button_presence
            when :browser
              print_buttons_browser += 1
              puts "   ↳ (print_button is browser-print — skipped)"
            when :actionable
              tested = click_and_check_all_print_pdfs!   # ← clicks ALL matching buttons
              print_buttons_actionable += tested
              print_buttons_passed     += tested
            else
              puts "   ↳ (no print_button present)"
            end
          rescue => e
            failed << { section:, href: "#{href} [print_button]", error: e.message }
            puts "\e[31m   ↳ 💥 print_button failed — #{e.class}: #{e.message}\e[0m"
          end

          passed << { section:, href:, title: title }
          puts "\e[32m✅ Opened: #{href}#{" — '#{title}'" if title}\e[0m"
        rescue => e
          failed << { section:, href:, error: e.message }
          puts "\e[31m💥 Failed: #{href} — #{e.class}: #{e.message}\e[0m"
        ensure
          visit home_path
        end
      end
    end

    # --- Totals & summary ---------------------------------------------------

    puts "\n\e[32m✅ #{passed.count} passed\e[0m"
    puts "\e[33m⚠️  #{skipped.count} skipped\e[0m"
    puts "\e[31m❌ #{failed.count} failed\e[0m"

    if skipped.any?
      puts "\n\e[33mSkipped details:\e[0m"
      skipped.each { |s| puts " - [#{s[:section]}] #{s[:href]} — #{s[:reason]}" }
    end

    # Pretty end-of-run summary focused on the header actions
    puts "\n\e[36m📊 Summary:\e[0m"
    puts "   New buttons:   #{new_buttons_passed}/#{new_buttons_actionable} passed"
    puts "   Print (PDF):   #{print_buttons_passed}/#{print_buttons_actionable} passed" +
         (print_buttons_browser.positive? ? "  (#{print_buttons_browser} browser-print skipped)" : "")

    expect(failed).to be_empty, "Some navigation links failed to open or validate"
  end
end
