module ApplicationHelper

  # --- Turbo and Page Helpers ---
  def render_turbo_stream_flash_messages
    turbo_stream.prepend "flash", partial: "layouts/flash"
  end

  def title(page_title)
    content_for :title, page_title.to_s
  end

  # --- Form and Field Error Helpers ---
  def form_errors_for(record)
    return unless record.errors.any?
  
    content_tag :div, class: "bg-red-100 border border-red-400 text-red-700 rounded p-4 mb-4" do
      concat content_tag(:h2, "#{pluralize(record.errors.count, 'error')} prohibited this record from being saved:", class: "font-semibold text-sm mb-2")
  
      list_items = record.errors.full_messages.map { |msg| content_tag(:li, msg) }.join.html_safe
  
      concat content_tag(:ul, list_items, class: "list-disc pl-5 text-sm")
    end
  end
  
  def field_error_for(record, field)
    return if record.blank? || record.errors[field].blank?
  
    content_tag(:p, record.errors[field].first, class: "text-sm text-red-600 mt-1")
  end

  # --- Navigation Box Classes ---
  def nav_box_class
    "w-64 h-32 bg-gray-800 text-gray-50 p-6 rounded-lg text-center font-semibold shadow-md hover:shadow-lg hover:scale-105 hover:ring hover:ring-offset-2 hover:ring-gray-300 transition-transform duration-200 ease-in-out flex items-center justify-center text-lg"
  end

  def nav_box_inverse_class
    "w-64 h-32 bg-white text-gray-800 p-6 rounded-lg text-center font-bold border-4 border-gray-800 shadow-md hover:shadow-lg hover:scale-105 hover:ring hover:ring-offset-2 hover:ring-gray-300 transition-transform duration-200 ease-in-out flex items-center justify-center text-lg"
  end

  def nav_box_assigned_class
    "w-64 h-32 bg-white text-gray-800 p-6 rounded-lg text-center font-bold border-4 border-green-500 shadow-md hover:shadow-lg hover:scale-105 hover:ring hover:ring-offset-2 hover:ring-green-300 transition-transform duration-200 ease-in-out flex items-center justify-center text-lg"
  end

  def nav_box_cutting_class
    "w-64 h-32 bg-white text-gray-800 p-6 rounded-lg text-center font-bold border-4 border-blue-600 shadow-md hover:shadow-lg hover:scale-105 hover:ring hover:ring-offset-2 hover:ring-blue-300 transition-transform duration-200 ease-in-out flex items-center justify-center text-lg"
  end

  # --- Text and Label Classes ---
  def information_text_class
    "text-base text-left font-normal"
  end

  def title_two
    "text-lg font-extrabold"
  end

  def link_class
    "text-md font-medium hover:italic hover:text-gray-600 hover:underline hover:underline-offset-4"
  end

  def departments_link_class
    "text-xs font-medium hover:opacity-50 hover:underline hover:underline-offset-4"
  end

  def label_class
    "font-semibold pt-4 pb-1"
  end

  # --- Field Input Classes ---
  BASE_FIELD_CLASS = "shadow outline-none rounded-lg border border-gray-800"

  def field_class_flex
    "#{BASE_FIELD_CLASS} bg-gray-100 text-gray-800 py-2 px-3 w-60 focus:border-gray-500 focus:ring-1 focus:ring-gray-300 focus:outline-none"
  end

  def field_class
    "#{BASE_FIELD_CLASS} bg-gray-100 font-gray-800 px-3 w-60 focus:border-gray-500 focus:ring-1 focus:ring-gray-300 focus:outline-none"
  end

  def field_class_flex_lg
    "#{BASE_FIELD_CLASS} bg-gray-100 text-gray-800 py-2 px-3 w-96 focus:border-gray-500 focus:ring-1 focus:ring-gray-300 focus:outline-none"
  end

  def field_class_unsized
    "#{BASE_FIELD_CLASS} bg-gray-100 font-gray-800 px-3 w-full focus:border-gray-500 focus:ring-1 focus:ring-gray-300 focus:outline-none"
  end

 

  def field_class_flex_full
    "#{BASE_FIELD_CLASS} bg-gray-100 text-gray-800 py-2 px-3 w-full focus:border-gray-500 focus:ring-1 focus:ring-gray-300 focus:outline-none"
  end

  def field_class_flex_disabled
    "#{BASE_FIELD_CLASS} bg-gray-300 text-gray-800 py-2 px-3 w-60 focus:border-gray-500 focus:ring-1 focus:ring-gray-300 focus:outline-none"
  end

  def field_class_flex_full_disabled
    "#{BASE_FIELD_CLASS} bg-gray-300 text-gray-800 py-2 px-3 w-full focus:border-gray-500 focus:ring-1 focus:ring-gray-300 focus:outline-none"
  end

  def field_class_flex_med
    "#{BASE_FIELD_CLASS} bg-gray-100 text-gray-800 max-w-44 py-2 px-2 text-right w-60 focus:border-gray-500 focus:ring-1 focus:ring-gray-300 focus:outline-none"
  end

  def field_class_flex_small
    "#{BASE_FIELD_CLASS} bg-gray-100 text-gray-800 max-w-20 h-10 px-2 text-center w-60 focus:border-gray-500 focus:ring-1 focus:ring-gray-300 focus:outline-none"
  end

  def checkbox_class
    "form-checkbox h-5 w-5 text-gray-800 rounded border-gray-800 focus:ring-1 focus:ring-gray-500 bg-gray-100 transition transform hover:scale-115 hover:shadow"
  end

  def checkbox_input_class
    "h-5 w-5 text-gray-800 border-gray-800 rounded focus:ring-gray-500 focus:ring-1"
  end

  def field_class_fit
    "#{BASE_FIELD_CLASS} bg-gray-50 text-gray-900 text-sm focus:ring-1 focus:ring-gray-300 focus:border-gray-500 block p-2.5 focus:outline-none"
  end

  def field_class_no_block
    "#{BASE_FIELD_CLASS} bg-gray-100 font-gray-800 px-3 w-60 focus:border-gray-500 focus:ring-1 focus:ring-gray-300 focus:outline-none"
  end

  # --- Filter and Button Classes ---
  def filter_drop_down
    "mt-1 block w-full px-4 py-1 text-sm border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-gray-500 focus:border-gray-500"
  end

  def filter_button
    "mt-1 block w-full px-4 py-1 text-sm text-white border border-gray-300 bg-gray-800 rounded-md shadow-sm focus:outline-none focus:ring-gray-500 focus:border-gray-500"
  end

  def clear_filter_button
    "mt-1 block w-full px-4 py-1 text-sm text-gray-800 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-gray-500 focus:border-gray-500"
  end

  def gray_button
    "my-4 rounded-lg py-2 px-4 bg-gray-100 inline-block font-semibold"
  end

  def clear_button_class
    "bg-transparent text-sm hover:bg-gray-200 hover:text-gray-600 font-semibold mt-4 my-4 py-2 px-4 border border-gray-900 hover:border-transparent rounded-lg"
  end

  def tight_clear_button_class
    "bg-transparent hover:bg-gray-600 text-gray-800 font-semibold hover:text-white py-2 px-4 w-auto border border-gray-900 hover:border-transparent rounded-lg text-sm leading-tight"
  end
  
  def tight_fill_button_class
    "bg-gray-800 hover:bg-gray-600 text-white font-semibold hover:text-white py-2 px-4 w-auto border border-gray-900 hover:border-transparent rounded-lg text-sm leading-tight"
  end

  def fill_button_class
    "bg-gray-800 text-white hover:bg-gray-600 font-semibold hover:text-white mt-4 my-4 py-2 px-4 border border-gray-900 hover:border-transparent rounded-lg"
  end

  def fill_button_large_class
    "bg-gray-800 text-white text-xl font-semibold hover:bg-gray-600 hover:text-white mt-6 mb-6 py-4 px-8 border border-gray-900 hover:border-transparent rounded-2xl shadow-lg transition-transform duration-150 ease-in-out"
  end

  def fill_button_small_class
    "bg-gray-800 text-xs text-white hover:bg-gray-600 font-semibold hover:text-white mt-4 my-2 py-2 px-2 border border-gray-900 hover:border-transparent rounded-lg"
  end

  def header_bar_button_class
    "text-xs text-center font-semibold hover:bg-grey-600 bg-gray-800 p-1 pl-4 pr-4 text-gray-100 border border-gray-200 rounded-lg"
  end

  # --- Dropdown and Table ---
  def dropdown_list_class
    "block px-4 py-2 hover:bg-gray-100"
  end

  def table_head_class
    "text-xs text-gray-700 uppercase bg-gray-200"
  end

  # --- Calculation Helpers (also used in PDF) ---
  def weight_of_whole_cheese(product)
    Calculation.where(product: product, size: "Whole").pluck(:weight)
  end

  def get_weight_of_group(picksheet_items)
    picksheet_items.map(&:get_weight).sum
  end

  def how_many_cheeses_do_i_need(product, picksheet_items)
    weight_of_cheese_ordered_in_g = get_weight_of_group(picksheet_items) * 1000
    weight_of_one_whole_cheese = weight_of_whole_cheese(product).first.to_i
    (weight_of_cheese_ordered_in_g.to_f / weight_of_one_whole_cheese.to_f).round(1)
  end

  # --- Utility Helpers ---
  def boolean_label(value)
    return "" if value.blank?
    value ? "YES" : "NO"
  end

  def contact_ids
    Makesheet.where.not(status: "Finished").pluck(:contact_id).compact.uniq
  end

  # --- Reference Data Helpers ---
  def reference_group
    Reference.order(:group).pluck(:group).uniq
  end

  def batch_status; Reference.where(active: true, group: 'batch_status').order(:sort_order).pluck(:value); end
  def bucket_weight; Reference.where(active: true, group: 'bucket_weight').pluck(:value); end
  def carrier; Reference.where(active: true, group: 'carrier').order(:sort_order).pluck(:value); end
  def cheese_accompaniments; Reference.where(active: true, group: 'cheese_accompaniments').order(:sort_order).pluck(:value); end
  def cut_guest_cheeses; Reference.where(active: true, group: 'cut_guest_cheeses').order(:sort_order).pluck(:value); end
  def department; Reference.where(active: true, group: 'department').order(:sort_order).pluck(:value); end
  def employment_status; Reference.where(active: true, group: 'employment_status').order(:sort_order).pluck(:value); end
  def farmers_markets; Reference.where(active: true, group: 'farmers_markets').order(:sort_order).pluck(:value); end
  def grade; Reference.where(active: true, group: 'grade').order(:sort_order).pluck(:value); end
  def grade_appearance; Reference.where(active: true, group: 'grade_appearance').order(:sort_order).pluck(:value); end
  def grade_bore; Reference.where(active: true, group: 'grade_bore').order(:sort_order).pluck(:value); end
  def grade_taste; Reference.where(active: true, group: 'grade_taste').order(:sort_order).pluck(:value); end
  def grade_texture; Reference.where(active: true, group: 'grade_texture').order(:sort_order).pluck(:value); end
  def location_type_options; Reference.where(active: true, group: 'location_type_options').order(:sort_order).pluck(:value); end
  def make_type; Reference.where(active: true, group: 'make_type').order(:sort_order).pluck(:value); end
  def makesheet_mill; Reference.where(active: true, group: 'makesheet_mill').order(:sort_order).pluck(:value); end
  def pick_status; Reference.where(active: true, group: 'pick_status').order(:sort_order).pluck(:value); end
  def sale_pricing; Reference.where(active: true, group: 'sale_pricing').order(:sort_order).pluck(:value); end
  def sale_product; Reference.where(active: true, group: 'sale_product').order(:sort_order).pluck(:value); end
  def sale_product_butter; Reference.where(active: true, group: 'sale_product_butter').order(:sort_order).pluck(:value); end
  def sale_product_other; Reference.where(active: true, group: 'sale_product_other').order(:sort_order).pluck(:value); end
  def sale_size; Reference.where(active: true, group: 'sale_size').order(:sort_order).pluck(:value); end
  def scale_name_serial; Reference.where(active: true, group: 'scale_name_serial').order(:sort_order).pluck(:value); end
  def scalecheck_frequency; Reference.where(active: true, group: 'scalecheck_frequency').order(:sort_order).pluck(:value); end
  def starter_culture; Reference.where(active: true, group: 'starter_culture').order(:sort_order).pluck(:value); end
  def trafficlights; Reference.where(active: true, group: 'trafficlights').order(:sort_order).pluck(:value); end
  def turned_by; Reference.where(active: true, group: 'turned_by').order(:sort_order).pluck(:value); end
  def vacuum_pouches; Reference.where(active: true, group: 'vacuum_pouches').order(:sort_order).pluck(:value); end
  def wash_status; Reference.where(active: true, group: 'wash_status').order(:sort_order).pluck(:value); end
  def weather; Reference.where(active: true, group: 'weather').order(:sort_order).pluck(:value); end
  def weight_type; Reference.where(active: true, group: 'weight_type').order(:sort_order).pluck(:value); end
  def wedges_sizes; Reference.where(active: true, group: 'wedges_sizes').order(:sort_order).pluck(:value); end
  def yes_no; [["Yes", true], ["No", false]]; end
  
  def scale_check_type(scale_name)
    Reference.find_by(group: 'scale_name_serial', value: scale_name)&.description
  end
end
