module PicksheetsHelper
  def sort_link(column:, label:)
    direction = column == params[:column] ? next_direction : 'asc'
    link_to(label, picksheets_path(column: column, direction: direction), data: { turbo_action: 'replace' })
  end
  
  def next_direction
     params[:direction] == 'asc' ? 'desc' : 'asc'
   end
   
   def sort_indicator
     tag.span(class: "sort sort-#{params[:direction]}")
   end

   def show_sort_indicator_for(column)
     sort_indicator if params[:column] == column
   end

    # "24/09/25 (Tuesday/tomorrow)" style
    def format_due_with_relative(date, today: Time.zone.today)
      return "-" if date.blank?
      d = date.to_date
      rel =
        if d == today
          "today"
        elsif d == today + 1
          "tomorrow"
        elsif d == today - 1
          "yesterday"
        elsif (d - today).between?(2, 7)
          d.strftime("%A") # within a week, show weekday name
        else
          d.strftime("%A") # otherwise also show weekday
        end
      "#{d.strftime('%d/%m/%y')} (#{rel})"
    end
  
    def due_pill_classes(date, today: Time.zone.today)
      return "bg-gray-100 text-gray-700" if date.blank?
      d = date.to_date
      if d < today
        "bg-red-100 text-red-700"
      elsif d == today
        "bg-amber-100 text-amber-800"
      elsif d <= today + 2
        "bg-yellow-100 text-yellow-800"
      else
        "bg-emerald-100 text-emerald-800"
      end
    end
  
end
