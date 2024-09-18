module MakesheetsHelper
  
  def direction
     params[:direction] == "asc" ? "desc" : "asc"
   end

   def filter_arrow(column)
     if params[:column] == column
       if params[:direction] == "asc"
         "&#8659;".html_safe
       else
         "&#8657;".html_safe
       end
     end
   end
end
