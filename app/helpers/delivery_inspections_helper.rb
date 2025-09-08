# app/helpers/delivery_inspections_helper.rb
module DeliveryInspectionsHelper
  def di_used_any?(di)
    di.association(:makesheets).loaded? ? di.makesheets.any? : di.makesheets.exists?
  end

  def di_is_current?(di, current_by_item)
    current_by_item[di.item] == di.id
  end

  def di_row_classes(di, current_by_item)
    # base row classes only — no background needed anymore
    ["bg-white", "border-b", "hover:bg-gray-100"].join(" ")
  end

  def current_row_first_cell_classes(di, current_by_item)
    if di.apply_hold?   # ✅ red wins
      "border-l-4 border-red-600"
    elsif di_is_current?(di, current_by_item)
      "border-l-4 border-green-500"
    elsif di_used_any?(di)
      "border-l-4 border-gray-400"
    else
      ""
    end
  end
end





