# spec/features/page_smoke_dynamic_spec.rb
# frozen_string_literal: true
require "rails_helper"

RSpec.feature "PageSmoke (dynamic)", type: :feature do

  # --- Helpers go here ---
  def header_page_title
    page.first("header .flex-grow.text-base", wait: false)&.text&.strip
  end

  def status_ok?
    page.respond_to?(:status_code) ? (200..399).cover?(page.status_code) : true
  end
  # ------------------------

  
  EXCLUDE_CONTROLLERS_PREFIX = %w[devise rails/active_storage action_mailbox/ingresses action_text letter_opener].freeze
  OUT_OF_SCOPE_CONTROLLERS   = %w[invoices market_sales validation_ranges wash_picksheets].freeze
  OUT_OF_SCOPE_PATHS         = [%r{\A/letter_opener}, %r{\A/rails/active_storage}, %r{\A/assets}].freeze

  SAFE_ACTIONS = %w[
    index new summary week_view preload rolling_geo_average
    home dairy_home store_home wash_home cutting_home office_home mgmt_home
    credits graded_blackboard monthly_summary overview recent
  ].freeze

  SKIP_PATHS_REGEX = %r{/print|/pdf|/show_pdf|/preview|/qr_code|/create_month|/report|/inspection}i

  TITLE_OVERRIDES = {
    "pages#dairy_home"  => "DAIRY",
    "pages#store_home"  => "STORE",
    "pages#wash_home"   => "WASH",
    "pages#cutting_home"=> "CUTTING",
    "pages#office_home" => "OFFICE",
    "pages#mgmt_home"   => "MANAGEMENT",
    "pages#credits"     => "CREDITS",
    "vacuum_pouch_calculator#new" => "WEIGHT CALCULATOR",
    "cleaning_foreign_body_checks#index"     => "CLEANING AND FOREIGN BODY CHECKS",
    "cleaning_foreign_body_checks#week_view" => "CLEANING AND FOREIGN BODY CHECKS: WEEK VIEW",
    "scale_checks#index" => "SCALE CHECKS",
    "scale_checks#week_view" => "SCALE CHECKS: WEEK VIEW",
    "grading_notes#index" => "GRADING",
    "grading_notes#preload" => "PRELOAD GRADING NOTES WIZARD",
    "invoices#index" => "INVOICES",
    "invoices#summary" => "INVOICES SUMMARY",
    "market_sales#index" => "MARKET SALES",
    "market_sales#summary" => "MARKET SALES SUMMARY",
    "palletised_distributions#index" => "PALLETISED DISTRIBUTION VEHICLE DETAILS",
    "batch_weights#index" => "CHEESE BATCH WEIGHTS",
    "breakages#index" => "BREAKAGES",
    "chillers#index" => "CHILLER TEMPERATURE DISPLAY",
    "butter_makes#index" => "BUTTER MAKE SCHEDULE",
    "butter_stocks#index" => "BUTTER STOCK",
    "milk_quality_monitors#index" => "MILK QUALITY MONITOR",
    "milk_quality_monitors#rolling_geo_average" => "ROLLING GEO AVERAGE",
    "traceability_records#index" => "BATCH INDIVIDUAL TRACEABILITY",
    "samples#index" => "SAMPLES",
    "staffs#index" => "STAFF",
    "contacts#index" => "CUSTOMERS",
    "calculations#index" => "CALCULATIONS",
    "references#index" => "REFERENCE DATA",
    "washes#index" => "WASH LISTS",
    "makesheets#index" => "MAKESHEETS",
    "makesheets#monthly_summary" => "MONTHLY SUMMARY",
    "makesheets#graded_blackboard" => "GRADED WHITEBOARD",
    "turns#index" => "TURNS",
    "picksheets#index" => "PICKING SHEETS",
    "picksheets#open_picksheets" => "OPEN PICKING SHEETS",
    "picksheets#assigned_picksheets" => "ASSIGNED PICKING SHEETS",
    "picksheets#cutting_picksheets" => "CUTTING PICKING SHEETS",
    "picksheets#shipped_picksheets" => "SHIPPED PICKING SHEETS",
    "picksheets#dispatch_and_collection" => "DISPATCH AND COLLECTIONS",
    "picksheets#daily_cheese_manifest" => "DAILY CHEESE MANIFEST",
    "users#index" => "USERS",
  }.freeze

  def discover_paramless_get_paths
    Rails.application.routes.routes.filter_map do |r|
      verb = r.verb&.to_s
      next unless verb&.match?(/GET|^\^\\w+\$|^$/)

      defaults   = r.defaults || {}
      controller = defaults[:controller]
      action     = defaults[:action]
      next if controller.blank? || action.blank?

      next if EXCLUDE_CONTROLLERS_PREFIX.any? { |p| controller.start_with?(p) }
      next if OUT_OF_SCOPE_CONTROLLERS.include?(controller)
      next unless SAFE_ACTIONS.include?(action)

      raw  = r.path.spec.to_s
      path = raw.sub("(.:format)", "")
      next if path.include?("/:") || path.include?("*")
      next if OUT_OF_SCOPE_PATHS.any? { |rx| path.match?(rx) }
      next if path.match?(SKIP_PATHS_REGEX)

      path = "/" if path.blank?
      { path:, controller:, action:, key: "#{controller}##{action}" }
    end.uniq { |h| h[:path] }
  end

  def status_ok?
    page.respond_to?(:status_code) ? (200..399).cover?(page.status_code) : true
  end

  def yielded_page_title
    page.first("[data-test-page-title]", wait: false)&.text&.strip
  rescue Capybara::ExpectationNotMet
    nil
  end

  scenario "admin user loads all safe pages and sees content_for titles or OK status" do
    admin = create(:user, role: :admin)
    login_as(admin, scope: :user)

    discovered = discover_paramless_get_paths
    discovered << { path: root_path, controller: "pages", action: "home", key: "pages#home" }
    discovered.uniq! { |h| h[:path] }

    passed, failed, skipped = [], [], []

    discovered.each do |info|
      path = info[:path]
      begin
        visit path

        # 1) Specific page_title override?
        if (expected = TITLE_OVERRIDES[info[:key]]).present?
          if page.has_text?(/#{Regexp.escape(expected)}/i) || yielded_page_title&.casecmp?(expected)
            puts "\e[32m✅ #{path} — page_title '#{expected}'\e[0m"
            passed << path
          else
            puts "\e[31m💥 #{path} — missing page_title '#{expected}'\e[0m"
            failed << { path:, key: info[:key], reason: "missing page_title '#{expected}'" }
          end
          next
        end

        # 2) Otherwise accept content_for :page_title if present
        pt = yielded_page_title
        if pt.present?
          puts "\e[32m✅ #{path} — page_title '#{pt}'\e[0m"
          passed << path
          next
        end

        # 3) Fallback: document <title> or OK status
        if page.title.present?
          puts "\e[32m✅ #{path} — <title> '#{page.title}'\e[0m"
          passed << path
        elsif status_ok?
          puts "\e[32m✅ #{path} — status OK (no titles found)\e[0m"
          passed << path
        else
          puts "\e[33m⚠️  #{path} — skipped (no titles, unknown status)\e[0m"
          skipped << path
        end
      rescue => e
        if path.match?(SKIP_PATHS_REGEX) || e.message =~ /Couldn't find .* without an ID/ ||
           e.is_a?(AbstractController::ActionNotFound)
          puts "\e[33m⚠️  #{path} — skipped (#{e.class}: #{e.message})\e[0m"
          skipped << path
        else
          puts "\e[31m💥 #{path} — #{e.class}: #{e.message}\e[0m"
          failed << { path:, error: "#{e.class}: #{e.message}" }
        end
      end
    end

    puts "\nSummary:"
    puts "  ✅ Passed:  #{passed.count}"
    puts "  ⚠️  Skipped: #{skipped.count}"
    puts "  ❌ Failed:  #{failed.count}"

    expect(failed).to be_empty, "Some pages failed: #{failed.inspect}"
  end
end

