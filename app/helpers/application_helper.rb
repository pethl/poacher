module ApplicationHelper
 
  def render_turbo_stream_flash_messages
     turbo_stream.prepend "flash", partial: "layouts/flash"
   end

   def title(page_title)
    content_for :title, page_title.to_s
  end

  def form_errors_for(record)
    return unless record.errors.any?

    content_tag :div, class: "bg-red-100 border border-red-400 text-red-700 rounded p-4 mb-4" do
      concat content_tag(:h2, "#{pluralize(record.errors.count, 'error')} prohibited this record from being saved:", class: "font-semibold text-sm mb-2")

      concat content_tag(:ul, class: "list-disc pl-5 text-sm") {
        record.errors.full_messages.map { |msg| content_tag(:li, msg) }.join.html_safe
      }
    end
  end

  def field_error_for(record, field)
    return unless record.errors[field].any?

    content_tag(:p, record.errors[field].first, class: "text-sm text-red-600 mt-1")
  end

  def nav_box_class
    "w-64 h-32 bg-gray-800 text-gray-50 p-6 rounded-lg text-center font-semibold shadow-md
     hover:shadow-lg hover:scale-105 hover:ring hover:ring-offset-2 hover:ring-gray-300
     transition-transform duration-200 ease-in-out flex items-center justify-center text-lg"
  end
  
  def nav_box_inverse_class
    "w-64 h-32 bg-white text-gray-800 p-6 rounded-lg text-center font-bold border-4 border-gray-800 shadow-md
     hover:shadow-lg hover:scale-105 hover:ring hover:ring-offset-2 hover:ring-gray-300
     transition-transform duration-200 ease-in-out flex items-center justify-center text-lg"
  end

  def nav_box_assigned_class
    "w-64 h-32 bg-white text-gray-800 p-6 rounded-lg text-center font-bold border-4 border-green-500 shadow-md
    hover:shadow-lg hover:scale-105 hover:ring hover:ring-offset-2 hover:ring-green-300
    transition-transform duration-200 ease-in-out flex items-center justify-center text-lg"
  end

  def nav_box_cutting_class
    "w-64 h-32 bg-white text-gray-800 p-6 rounded-lg text-center font-bold border-4 border-blue-600 shadow-md
    hover:shadow-lg hover:scale-105 hover:ring hover:ring-offset-2 hover:ring-blue-300
    transition-transform duration-200 ease-in-out flex items-center justify-center text-lg"
  end
   
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

   def field_class
    "outline:none shadow rounded-lg border border-gray-800 bg-gray-100 outline-none font-gray-800 px-3 w-60"
   end
   
   def field_class_unsized
    "w-full outline:none shadow rounded-lg border border-gray-800 bg-gray-100 font-gray-800 px-3 focus:border-gray-800 "
   end
 
   def field_class_flex
    "shadow outline:none rounded-lg border border-gray-800 bg-gray-100 text-gray-800 py-2 px-3 w-60 focus:border-gray-800 "
   end
   def field_class_flex_full
    "shadow outline:none py-2 rounded-lg border border-gray-800 bg-gray-100 text-gray-800 px-3 w-full focus:border-gray-800 "
   end

   def field_class_flex_disabled
    "shadow outline:none py-2 rounded-lg border border-gray-800 bg-gray-300 text-gray-800 px-3 w-60 focus:border-gray-800 "
   end

   def field_class_flex_full_disabled
    "shadow outline:none py-2 rounded-lg border border-gray-800 bg-gray-300 text-gray-800 px-3 w-full focus:border-gray-800 "
   end

   def field_class_flex_med
    "max-w-44 py-2 text-right shadow outline:none rounded-lg border border-gray-800 bg-gray-100 text-gray-800 px-2 w-60 focus:border-gray-800 "
   end

   def field_class_flex_small
    "max-w-20 h-10 shadow text-center outline:none rounded-lg border border-gray-800 bg-gray-100 text-gray-800 px-2 w-60 focus:border-gray-800 "
   end
   
   def field_class_fit
    "outline:none shadow bg-gray-50 border border-gray-800 text-gray-900 text-sm rounded-lg focus:ring-gray-600 focus:border-gray-800 block p-2.5 "
   end
   
   def field_class_no_block
    "block outline:none shadow rounded-lg border border-gray-800 bg-gray-100 font-gray-800 px-3 w-60"
   end

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
     "mt-2 rounded-lg py-2 px-4 bg-gray-100 inline-block font-medium"
   end 
 
   def clear_button_class
     "bg-transparent text-sm hover:bg-gray-200 hover:text-gray-600 font-semibold hover:text-white mt-4 my-4 py-2 px-4 border border-gray-900 hover:border-transparent rounded-lg"
   end
   
   def tight_clear_button_class
     "bg-transparent hover:bg-gray-600 font-semibold hover:text-white p-2 w-full border border-gray-900 hover:border-transparent rounded-lg"
   end

   def tight_fill_button_class
    "bg-gray-800 hover:bg-gray-600 font-semibold hover:text-white p-2 w-full border border-gray-900 hover:border-transparent rounded-lg"
  end
   
   def fill_button_class
      "bg-gray-800 text-white hover:bg-gray-600 font-semibold hover:text-white mt-4 my-4 py-2 px-4 border border-gray-900 hover:border-transparent rounded-lg"
   end

   def fill_button_small_class
      "bg-gray-800 text-xs text-white hover:bg-gray-600 font-semibold hover:text-white mt-4 my-2 py-2 px-2 border border-gray-900 hover:border-transparent rounded-lg"
   end
    
    def tight_fill_button_class
      "bg-gray-800 hover:bg-gray-600 text-white font-semibold hover:text-white mt-2 mb-2 p-2 border border-gray-900 hover:border-transparent rounded-lg"
    end
    
    def header_bar_button_class
      "text-xs text-center font-semibold hover:bg-grey-600 bg-gray-800 p-1 pl-4 pr-4 text-gray-100 border border-gray-200 rounded-lg"
    end
   
   def dropdown_list_class
     "block px-4 py-2 hover:bg-gray-100 "
   end
   
   def table_head_class
     "text-xs text-gray-700 uppercase bg-gray-200"
   end
   
  
   #THIS SECTION DUPED TO WASHES CONTROLLER FOR PDF
   def weight_of_whole_cheese(product)
     product_name = product
     Calculation.where(product: product_name, size: "Whole").pluck(:weight)
   end
   
   def get_weight_of_group(picksheet_items)
     picksheet_items.map(&:get_weight).sum 
   end
   
   # This takes input of ordered cheese weight (in kgs) and product name, 
   def how_many_cheeses_do_i_need(product, picksheet_items)
     
    weight_of_cheese_ordered_in_g = get_weight_of_group(picksheet_items)*1000
    
    weight_of_one_whole_cheese = weight_of_whole_cheese(product).first.to_i
    
    (weight_of_cheese_ordered_in_g.to_f/weight_of_one_whole_cheese.to_f).round(1) 
   end

   #handle booleans for display
   def boolean_label(value)
    if value.nil?
      return ""
       elsif value.blank? == true
      return ""
    elsif value == true
      return "YES"
    else
      return "NO"
    end
  end

  # for customers with special batch selections
  def contact_ids
    contact_ids = Makesheet.where.not(status: "Finished").pluck(:contact_id).compact.uniq
  end
   
   #REFERENECE DATA ONLY
    def reference_group
      reference_group = Reference.all.order(group: :asc)
      reference_group = reference_group.pluck(:group) 
      reference_group = reference_group.uniq() 
    end

   def weight_type
    Reference.where(active: true, group: 'weight_type').pluck(:value)       
   end
   
   def grade
    Reference.where(active: true, group: 'grade').pluck(:value)      
   end
   
   def turned_by
    Reference.where(active: true, group: 'turned_by').pluck(:value)      
   end
   
   def wash_status
    Reference.where(active: true, group: 'wash_status').pluck(:value)       
   end

   def carrier
    Reference.where(active: true, group: 'carrier').pluck(:value)      
  end

  def pick_status
    Reference.where(active: true, group: 'pick_status').order(:description).pluck(:value)       
  end

  def department
    Reference.where(active: true, group: 'department').pluck(:value)      
  end

  def employment_status
    Reference.where(active: true, group: 'employment_status').pluck(:value)       
  end

  def trafficlights
    Reference.where(active: true, group: 'trafficlights').pluck(:value)    
  end

  def batch_status
    Reference.where(active: true, group: 'batch_status').pluck(:value)       
  end

  def make_type
    Reference.where(active: true, group: 'make_type').pluck(:value)       
  end

  def weather
    Reference.where(active: true, group: 'weather').pluck(:value)
  end

  def starter_culture
    Reference.where(active: true, group: 'starter_culture').pluck(:value)
  end

  def yes_no
    #yes_no = Reference.where(active: "TRUE", group: 'yes_no')
    #yes_no = yes_no.pluck(:value)    
    yes_no =  [["Yes", true], ["No", false]]
  end

  def farmers_markets
    farmers_markets = Reference.where(active: "TRUE", group: 'farmers_markets')
    farmers_markets = farmers_markets.pluck(:value) 
  end

  def makesheet_mill
    Reference.where(active: true, group: 'makesheet_mill').pluck(:value)
  end

  def sale_product
    Reference.where(active: true, group: 'sale_product').order(:description).pluck(:value)
  end

  def sale_size
    Reference.where(active: true, group: 'sale_size').order(:description).pluck(:value)
  end

  def wedges_sizes
    Reference.where(active: true, group: 'wedges_sizes').order(:description).pluck(:value)
  end

  def sale_pricing
    Reference.where(active: true, group: 'sale_pricing').order(:description).pluck(:value)
  end

  def grade_appearance
    Reference.where(active: true, group: 'grade_appearance').order(:description).pluck(:value)
  end

  def grade_bore
    Reference.where(active: true, group: 'grade_bore').order(:description).pluck(:value)
  end

  def grade_texture
    Reference.where(active: true, group: 'grade_texture').order(:description).pluck(:value)
  end

  def grade_taste
    Reference.where(active: true, group: 'grade_taste').order(:description).pluck(:value)
  end

  
end
