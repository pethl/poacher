# app/helpers/ingredient_batch_changes_helper.rb
module IngredientBatchChangesHelper
  # Which ingredient items to show, based on make_type / rennet choice.
  # IMPORTANT: these strings must match DeliveryInspection.item values.
  def required_items_for(makesheet)
    items = []

    # Starter – only the selected one (default to RA21 unless explicitly RA24)
    starter = makesheet.type_of_starter_culture_used.presence
    items << (starter == "RA24" ? "RA24" : "RA21")

    # Salt is always needed
    items << "Salt"

    # Rennet depends on rennet_used OR Red make
    rennet_item =
      if makesheet.rennet_used == "Vegetable" || makesheet.make_type == "Red"
        "Rennet - Vegetable"
      else
        "Rennet - Animal"
      end
    items << rennet_item

    # Extras for Red
    items.concat(%w[Annatto MD88]) if makesheet.make_type == "Red"

    items.uniq
  end

  # Last *linked* change for an item on THIS makesheet
  def latest_linked_change_for(makesheet, item)
    makesheet.ingredient_batch_changes
             .where(item: item)
             .order(changed_on: :desc, created_at: :desc)
             .first
  end

  # Latest change for an item that is effective on or before the makesheet date
  def current_batch_change_for(makesheet, item)
    scope = IngredientBatchChange.where(item: item)
    scope = scope.where("changed_on <= ?", makesheet.make_date) if makesheet.make_date.present?

    scope.includes(:delivery_inspection)
         .order(changed_on: :desc, created_at: :desc)
         .first
  end

  # What to display: link on this sheet (if any) OR current-by-date
  def display_change_for(makesheet, item)
    latest_linked_change_for(makesheet, item) || current_batch_change_for(makesheet, item)
  end

  # Latest recorded delivery for an item (even if not linked)
  def latest_delivery_for_item(item)
    DeliveryInspection.for_item(item).by_delivery_date_desc.first
  end

  # Optional: has this item ever been linked anywhere?
  def item_ever_linked?(item)
    IngredientBatchChange.exists?(item: item)
  end
end
