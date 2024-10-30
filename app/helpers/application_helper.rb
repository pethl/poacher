module ApplicationHelper
 
  def render_turbo_stream_flash_messages
     turbo_stream.prepend "flash", partial: "layouts/flash"
   end
   
   def information_text_class
     "text-base text-left font-normal"
   end
  
   def link_class
     "text-md font-medium hover:italic hover:text-green-600 hover:underline hover:underline-offset-4"
   end

   def departments_link_class
    "text-xs font-medium hover:opacity-50 hover:underline hover:underline-offset-4"
  end
   
   def label_class
    "block font-semibold pt-4 pb-1"
   end

   def field_class
    "block shadow rounded-lg border border-green-800 bg-green-100 outline-none font-green-800 px-3 w-60"
   end
   
   def field_class_unsized
    "w-full outline:none shadow rounded-lg border border-green-800 bg-green-100 outline-none font-green-800 px-3 focus:border-green-800 "
   end
 
   def field_class_flex
    "shadow outline:none rounded-lg border border-green-800 bg-gray-100 outline-none text-green-800 px-3 w-60 focus:border-green-800 "
   end
   
   def field_class_fit
    "outline:none shadow bg-gray-50 border border-green-800 text-gray-900 text-sm rounded-lg focus:ring-green-600 focus:border-green-800 block p-2.5 "
   end
   
   def field_class_no_block
    "block outline:none shadow rounded-lg border border-green-800 bg-green-100 outline-none font-green-800 px-3 w-60"
   end
   
   def gray_button
     "mt-2 rounded-lg py-3 px-5 bg-gray-100 inline-block font-medium"
   end 
 
   def clear_button_class
     "min-w-40 bg-transparent text-sm hover:bg-green-600 font-semibold hover:text-white mt-8 my-4 py-2 px-4 border border-green-900 hover:border-transparent rounded-lg"
   end
   
   def tight_clear_button_class
     "bg-transparent hover:bg-green-600 font-semibold hover:text-white p-2 w-full border border-green-900 hover:border-transparent rounded-lg"
   end
   
   def fill_button_class
      "bg-green-800 text-white hover:bg-green-600 font-semibold hover:text-white mt-8 my-4 py-2 px-4 border border-green-900 hover:border-transparent rounded-lg"
    end
    
    def tight_fill_button_class
      "bg-green-800 hover:bg-green-600 text-white font-semibold hover:text-white mt-2 mb-2 p-2 border border-green-900 hover:border-transparent rounded-lg"
    end
    
    def header_bar_button_class
      "text-xs text-right hover:bg-green-600 p-1 font-base border border-gray-100 rounded-md"
    end
   
   def dropdown_list_class
     "block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
   end
   
   def table_head_class
     "text-xs text-gray-700 uppercase bg-gray-200 dark:bg-gray-700 dark:text-gray-400"
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
   
   #REFERENECE DATA ONLY
    def reference_group
      reference_group = Reference.all.order(group: :asc)
      reference_group = reference_group.pluck(:group) 
      reference_group = reference_group.uniq() 
    end

   def weight_type
     weight_type = Reference.where(active: "TRUE", group: 'weight_type')
     weight_type = weight_type.pluck(:value)       
   end
   
   def sale_size
     sale_size = Reference.where(active: "TRUE", group: 'sale_size')
     sale_size = sale_size.pluck(:value)       
   end
   
   def grade
     grade = Reference.where(active: "TRUE", group: 'grade')
     grade = grade.pluck(:value)       
   end
   
   def turned_by
     turned_by = Reference.where(active: "TRUE", group: 'turned_by')
     turned_by = turned_by.pluck(:value)       
   end
   
   def wash_status
     wash_status = Reference.where(active: "TRUE", group: 'wash_status')
     wash_status = wash_status.pluck(:value)       
   end

   def carrier
    carrier = Reference.where(active: "TRUE", group: 'carrier')
    carrier = carrier.pluck(:value)       
  end

  def pick_status
    pick_status = Reference.where(active: "TRUE", group: 'pick_status')
    pick_status = pick_status.pluck(:value)       
  end

  def department
    department = Reference.where(active: "TRUE", group: 'department')
    department = department.pluck(:value)       
  end

  def employment_status
    employment_status = Reference.where(active: "TRUE", group: 'employment_status')
    employment_status = employment_status.pluck(:value)       
  end
end
