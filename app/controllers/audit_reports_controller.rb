# app/controllers/audit_reports_controller.rb
class AuditReportsController < ApplicationController
  def show
    # Blank page until a makesheet is chosen
    unless params[:makesheet_id].present? || params[:make_date].present?
      @makesheet = nil
      @rows = []
      @di_hold_by_id = {}
      return
    end

    @makesheet = find_makesheet

    # 1) Which ingredients to show?
    @expected_items = expected_ingredients_for(@makesheet)

    # 2) Direct links on this makesheet (fast lookup by item)
    direct_links = IngredientBatchChange
                     .includes(:delivery_inspection)
                     .where(makesheet_id: @makesheet.id)
                     .group_by(&:item) # { "Salt" => [change, ...] }

    # 3) Fallback: latest prior/current batch as of this make_date
    fallback_by_item = {}
    @expected_items.each do |item|
      next if direct_links[item].present?

      fb = IngredientBatchChange
             .joins(:makesheet, :delivery_inspection)
             .where(item: item)
             .where("makesheets.make_date <= ?", @makesheet.make_date)
             .select(
               "ingredient_batch_changes.item AS item_name, " \
               "delivery_inspections.id AS di_id, " \
               "delivery_inspections.batch_no AS batch_no, " \
               "delivery_inspections.delivery_date AS delivery_date, " \
               "delivery_inspections.best_before AS best_before"
             )
             .order(Arel.sql("makesheets.make_date DESC, ingredient_batch_changes.changed_on DESC, delivery_inspections.delivery_date DESC, delivery_inspections.id DESC"))
             .limit(1)
             .first

      fallback_by_item[item] = fb if fb
    end

    # 4) Build rows for the view + collect DI ids for flags
    di_ids = []
    @rows = @expected_items.map do |item|
      if (chs = direct_links[item]).present?
        di = chs.first.delivery_inspection
        di_ids << di.id
        {
          item: item,
          source: :linked, # explicitly linked on this makesheet
          di_id: di.id,
          batch_no: di.batch_no,
          delivery_date: di.delivery_date,
          best_before: di.best_before
        }
      elsif (fb = fallback_by_item[item])
        di_ids << fb.di_id
        {
          item: item,
          source: :fallback, # latest prior/current as of this make_date
          di_id: fb.di_id,
          batch_no: fb.batch_no,
          delivery_date: fb.delivery_date,
          best_before: fb.best_before
        }
      else
        {
          item: item,
          source: :missing, # nothing found
          di_id: nil,
          batch_no: nil,
          delivery_date: nil,
          best_before: nil
        }
      end
    end

    # Optional: preload hold flags for legend bars in the audit table
    @di_hold_by_id = di_ids.uniq.any? ? DeliveryInspection.where(id: di_ids.uniq).pluck(:id, :apply_hold).to_h : {}
  end

  private

  def find_makesheet
    scope = Makesheet.includes(ingredient_batch_changes: :delivery_inspection)

    if params[:makesheet_id].present?
      scope.find(params[:makesheet_id])
    else
      # params[:make_date] present
      date = begin
        Date.parse(params[:make_date].to_s)
      rescue ArgumentError
        nil
      end
      raise ActiveRecord::RecordNotFound, "Invalid make_date" unless date
      scope.find_by!(make_date: date)
    end
  end

  # Determine the “expected” ingredients for this make_type.
  # Default: derive from recent history (last 10 makesheets of same type).
  # Falls back to your dairy_ingredients helper if history is empty.
  def expected_ingredients_for(makesheet)
    recent_ids = Makesheet.where(make_type: makesheet.make_type)
                          .order(make_date: :desc)
                          .limit(10)
                          .pluck(:id)

    items = IngredientBatchChange.where(makesheet_id: recent_ids).distinct.pluck(:item)

    if items.blank? && respond_to?(:dairy_ingredients)
      items = dairy_ingredients
    end

    items.sort
  end
end
