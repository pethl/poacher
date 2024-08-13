module ApplicationHelper
 
  def render_turbo_stream_flash_messages
     turbo_stream.prepend "flash", partial: "layouts/flash"
   end
   
   def label_class
    "block font-semibold pt-4 pb-1"
   end

   def field_class
    "block shadow rounded-lg border border-green-800 bg-green-100 outline-none font-green-800 px-3 w-60"
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
   

   def weight_type
     [
       ["Standard (20 kgs)"],
       ["Midi (8 kgs)"],
       ["2.5kg"]
   ]
   end
   
   def sale_size
     [
       ["Whole"],
       ["1/2"],
       ["1/4"],
       ["1/8"],
       ["1/16"],
       ["100g"],
       ["200g"],
       ["300g"]
   ]
   end
   
   def grade
     [
       ["Poacher"],
       ["Vintage"],
       ["Knuckle Duster"],
       ["P50"],
       ["Smoked"]
   ]
   end
   
   def turned_by
     [
       ["Florence"],
       ["By Hand"]
   ]
   end
end
