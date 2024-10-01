module ApplicationHelper
 
  def render_turbo_stream_flash_messages
     turbo_stream.prepend "flash", partial: "layouts/flash"
   end
  
   def link_class
     "text-md font-medium hover:italic hover:text-green-600 hover:underline hover:underline-offset-4"
   end
   
   def label_class
    "block font-semibold pt-4 pb-1"
   end

   def field_class
    "block shadow rounded-lg border border-green-800 bg-green-100 outline-none font-green-800 px-3 w-60"
   end
 
   def field_class_flex
    "shadow rounded-lg border border-green-800 bg-green-100 outline-none font-green-800 px-3 w-60"
   end
   
   def field_class_no_block
    "block shadow rounded-lg border border-green-800 bg-green-100 outline-none font-green-800 px-3 w-60"
   end
   
   def gray_button
     "mt-2 rounded-lg py-3 px-5 bg-gray-100 inline-block font-medium"
   end
 
   def clear_button_class
     "bg-transparent hover:bg-green-600 font-semibold hover:text-white mt-8 my-4 py-2 px-4 border border-green-900 hover:border-transparent rounded-lg"
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
   
   
   def dropdown_list_class
     "block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
   end
   
   def table_head_class
     "text-xs text-gray-700 uppercase bg-gray-200 dark:bg-gray-700 dark:text-gray-400"
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
end
