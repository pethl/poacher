module SamplesHelper
   
  def samples_sort_link(column:, label:)
    direction = column == params[:column] ? next_direction : 'asc'
    link_to(label, samples_path(column: column, direction: direction), data: { turbo_action: 'replace' })
  end
  
  def next_direction
     params[:direction] == 'asc' ? 'desc' : 'asc'
   end
   
   def sample_sort_indicator
     tag.span(class: "sort sort-#{params[:direction]}")
   end

   def samples_show_sort_indicator_for(column)
     sample_sort_indicator if params[:column] == column
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


   def sample_indicator_color(sample)
    value = sample.coagulase_positive_staphylococcus_37c_umqv9.to_s.strip
    description = sample.sample_description.to_s.strip
  
    if description.starts_with?("Young")
      return "green" if value.start_with?("<")
      return "red"   if value.gsub(",", "").to_i > 100_000
      return "yellow"
    end
  
    if description.starts_with?("Mature")
      return "green" if value.start_with?("<")
      return "red"   if value.gsub(",", "").to_i > 50_000
      return "yellow"
    end
  
    if description.include?("Raw Milk")
      # Fetch and normalize values
      
      apc = sample.aerobic_plate_count_30c.to_s.strip
      coliforms = sample.presumptive_coliforms.to_s.strip
      staph = sample.coagulase_positive_staphylococcus_37c_umqv9.to_s.strip
      salmonella = sample.salmonella.to_s.strip
  
      # Rules (adjust thresholds as needed)
      return "red" if salmonella.present?
  
      if numeric_value(apc) > 20_000 ||
         numeric_value(coliforms) > 100 ||
         numeric_value(staph) > 20
        return "red"
      end
  
      if apc.start_with?("<") && coliforms.start_with?("<") && staph.start_with?("<") && salmonella.blank?
        return "green"
      end
  
      return "yellow"
    end
  
    # Fallback
    case sample.indicator
    when "Green" then "green"
    when "Yellow" then "yellow"
    when "Red" then "red"
    else "gray"
    end
  end
  
  # Helper to handle numeric conversion safely
  def numeric_value(val)
    val.gsub(",", "").to_i
  end
  
   
end
