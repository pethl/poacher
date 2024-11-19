module TraceabilityRecordsHelper

  def traceability_sort_link(column:, label:)
    direction = column == params[:column] ? next_direction : 'asc'
    link_to(label, traceability_records_path(column: column, direction: direction), data: { turbo_action: 'replace' })
  end
  
  def next_direction
     params[:direction] == 'asc' ? 'desc' : 'asc'
   end
   
   def traceability_sort_indicator
     tag.span(class: "sort sort-#{params[:direction]}")
   end

   def traceability_show_sort_indicator_for(column)
    staff_sort_indicator if params[:column] == column
   end

   #NOT CURRENTLY IN USED
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
