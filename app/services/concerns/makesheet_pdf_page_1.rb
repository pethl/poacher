module MakesheetPdfPage1
  def draw_page_1(pdf, makesheet)
    pdf.font 'raleway'
   
    title =
    if makesheet.make_type == "Red"
      "LINCOLNSHIRE RED - MAKE SHEET"
    else
      "LINCOLNSHIRE POACHER - MAKE SHEET"
    end
  
  pdf.text title, size: 10, style: :bold, align: :right

    pdf.image @logo_img_path, 
    width: 70, 
    height: 70, 
    at: [
    pdf.bounds.left + (pdf.bounds.width - 70) / 2 -350 , # Centered horizontally
    pdf.bounds.bottom + 50                         # Keep vertical offset
  ]
  
     pdf.text "\n", size: 8  

     pdf.define_grid(columns: 3, rows: 1, gutter: 6)
     pdf.grid(0, 0).bounding_box do
       date_box = Array.new
       date_box << ["Date:", "<b>#{makesheet.make_date&.strftime('%b %d, %Y')}</b>"]
    
              pdf.table(date_box) do 
                self.width = 210
                 self.cell_style = { :inline_format => true, size: 8 } 
                 {:borders => [:top, :left, :bottom, :right],
                 :border_width => 1,
                 :border_color => "B2BEB5",}
                 columns(0).background_color = "D3D3D3"
                 columns(0).width = 50
                 columns(1).width = 160
                 rows(0).align = :left
                 rows(0).align = :center
                 columns(0).size = 8
                 columns(1).size = 12
            
               end
               pdf.text "\n", size: 6 
       
               first_column = Array.new 
               first_column << ["", "<b>TIME</b>", "<b>TEMP (°C)</b>"]
               first_column << ["<font size='7'>STEAM / HOT WATER ON</font>", "#{makesheet.steam_hot_water_on_time&.strftime('%I:%M')}", ""]
               first_column << ["<font size='7'>COLD MILK IN \nRECORD AS 'OK' IF &lt; 4°C</font>", "#{makesheet.cold_milk_in_time&.strftime('%I:%M')}", "#{makesheet.cold_milk_in_state}"]
               first_column << ["WARM MILK FINISH",  "#{makesheet.warm_milk_finish_time&.strftime('%I:%M')}", "#{makesheet.warm_milk_finish_titration}"]
               # Optional ANNATTO row
                    if makesheet.annatto_in_time.present? || makesheet.annatto_in_temp.present?
                      first_column << [
                        "ANNATTO",
                        makesheet.annatto_in_time&.strftime('%H:%M'),
                        makesheet.annatto_in_temp.to_s
                      ]
                    end
               first_column << ["STARTER IN",  "#{makesheet.starter_in_time&.strftime('%I:%M')}", "#{makesheet.starter_in_temp}"]
               # Optional MD88 row
                    if makesheet.md_88_in_time.present? || makesheet.md_88_in_temp.present?
                      first_column << [
                        "MD88",
                        makesheet.md_88_in_time&.strftime('%H:%M'),
                        makesheet.md_88_in_temp.to_s
                      ]
                    end
               first_column << ["HEAT OFF", "#{makesheet.heat_off_1_time&.strftime('%I:%M')}", "#{makesheet.heat_off_1_temp}"]
               # not on latest MS - first_column << ["MILK TITRATION", "#{makesheet.milk_titration_time&.strftime('%I:%M')}", "#{makesheet.milk_titration_temp}"]
               first_column << ["RENNET", "#{makesheet.rennet_time&.strftime('%I:%M')}", "#{makesheet.rennet_temp}"]
               first_column << ["CUT", "#{makesheet.cut_start_time&.strftime('%I:%M')}", "#{makesheet.cut_end_time&.strftime('%I:%M')}"]
               first_column << ["HEAT ON", "#{makesheet.heat_on_time&.strftime('%I:%M')}", ""]
               first_column << ["HEAT OFF", "#{makesheet.heat_off_2_time&.strftime('%I:%M')}", "#{makesheet.heat_off_2_temp}"]
               first_column << ["PITCH", "#{makesheet.pitch_time&.strftime('%I:%M')}", "<sup>Titration</sup>"]
               first_column << ["WHEY", "#{makesheet.whey_time&.strftime('%I:%M')}", "#{makesheet.whey_titration}"]
               first_column << ["1ST CUT", makesheet.first_cut_time&.strftime('%I:%M'), format_titration(makesheet.first_cut_titration)]
               first_column << ["2ND CUT", makesheet.second_cut_time&.strftime('%I:%M'), format_titration(makesheet.second_cut_titration)]
               first_column << ["3RD CUT", makesheet.third_cut_time&.strftime('%I:%M'), format_titration(makesheet.third_cut_titration)]
               first_column << ["4TH CUT", makesheet.fourth_cut_time&.strftime('%I:%M'), format_titration(makesheet.fourth_cut_titration)]
               first_column << ["5TH CUT", makesheet.fifth_cut_time&.strftime('%I:%M'), format_titration(makesheet.fifth_cut_titration)]
               first_column << ["6TH/MILL", makesheet.sixth_cut_time&.strftime('%I:%M'), format_titration(makesheet.sixth_cut_titration)]
               first_column << ["7TH/MILL", makesheet.seventh_cut_time&.strftime('%I:%M'), format_titration(makesheet.seventh_cut_titration)]

               first_column << [
                    "IDENTIFY MILL USED",
                    { content: "#{makesheet.identify_mill_used}</font>", colspan: 2 }
                  ]
                        
                  pdf.table(first_column, width: 210, cell_style: { inline_format: true }) do
                    # Column widths
                    columns(0).width = 100
                    columns(1).width = 55
                    columns(2).width = 55
                  
                    # Borders
                    cells.borders = [:top, :left, :bottom, :right]
                    cells.border_width = 1
                    cells.border_color = "000000"
                  
                    # Alignment
                    columns(0..2).align = :center
                  
                    # Background for header row
                    row(0).background_color = "D3D3D3"
                    row(0).height = 18
                    row(0).size = 6  # smaller font for header
                  
                    # Row 1: smaller
                    row(1).size = 8
                    row(1).height = 18
                  
                    # Middle rows: larger font
                    rows(2..-2).size = 9
                  
                    # Last row: "MILL"
                    last_row_index = first_column.length - 1
                    row(last_row_index).size = 9
                    row(last_row_index).height = 20
                  
                    # Optional grey cells
                    cells[1, 2].background_color = 'D3D3D3'
                    cells[2, 2].background_color = 'D3D3D3'
                    cells[8, 2].background_color = 'D3D3D3'
                    cells[10, 2].background_color = 'D3D3D3'
                    #cells[12, 2].background_color = 'D3D3D3'
                  end
                  
     end
     
     pdf.grid(0, 1).bounding_box do
      pdf.text "FW Read and Sons Ltd - Lincolnshire Poacher Cheese", size: 6, align: :left
      pdf.text "\n", size: 4

       milk_box = Array.new
       milk_box << [{ content: "<b>MILK USED</b>", colspan: 3 }, { content: "<b>BOTTLES back from F/Mkts</b>", colspan: 2 }]
       milk_box << ["Warm am","12 hr pm", "Record unusual smell or visual appearance","Number","U/B Date"]
       milk_box << ["<b>#{makesheet.warm_am == true ? "YES":  (makesheet.warm_am.nil? ? "" : "NO")}","<b>#{makesheet.twelve_hr_pm == true ? "YES":  (makesheet.twelve_hr_pm.nil? ? "" : "NO")}", "<b>#{makesheet.unusual_smell_appearance}","<b>#{makesheet.number_of_bottles_from_fm}","<b>#{makesheet.use_by_date_milk_from_fm&.strftime('%d-%m-%y')}</b>"]
      
              pdf.table(milk_box)  do 
                self.width = 250
                 self.cell_style = { :inline_format => true, size: 8, :height => 20 } 
                 {:borders => [:top, :left, :bottom, :right],
                 :border_width => 1,
                 :border_color => "B2BEB5",}
                 columns(0..1).width = 40
                 columns(2).width = 70
                 columns(3..4).width = 50
                 row(0).background_color = "D3D3D3"
                 rows(0).align = :center
                 rows(1).align = :center
                 rows(2).align = :center
                 columns(0..2).style(size: 8)   # first 3 columns
                 columns(3..4).style(size: 6)   # last 2 columns
                 rows(1).size = 6
                 rows(2).size = 9
                 #columns(0..4).size = 7
               end
               
         pdf.text "\n", size: 6  
          
         starter_box = []

          if makesheet.make_type == "Red"
            # red version with MD88
            starter_box << [{ content: "<b>STARTER CULTURE</b>", colspan: 3 }, "<b>MD88</b>", { content: "<b>RENNET</b>", colspan: 3 }]
            starter_box << ["Type Used", "Weight\n (g)", "Freezer \n °C", "MD88 Qty", "Type\n Used", "Weight\n (g)", "Chiller \n °C"]
            starter_box << [
              makesheet.type_of_starter_culture_used.to_s,
              makesheet.qty_of_starter_used ? sprintf('%.3f', makesheet.qty_of_starter_used) : '',
              makesheet.freezer_temp,
              makesheet.md_88_qty_used.to_s,
              makesheet.rennet_used,
              makesheet.rennet_weight_used,
              makesheet.chiller_temp
              
            ]

            pdf.table(starter_box) do
              self.width = 267
              self.cell_style = { inline_format: true }
              self.column_widths = [36, 38, 32, 35, 44, 33, 32 ]

              row(0).background_color = "D3D3D3"
              rows(0..2).align = :center
              rows(0).size = 7
              rows(1).size = 6
              rows(2).size = 7
              rows(2).height = 30
              row(-1).font_style = :bold
              row(-1).columns(4).size = 6 
              self.cell_style = {
                inline_format: true,
                borders: [:top, :left, :bottom, :right],
                border_width: 1,
                border_color: "000000"
              }
            end

          else
            #  (original)
            starter_box << [{ content: "<b>STARTER CULTURE</b>", colspan: 3 }, { content: "<b>RENNET</b>", colspan: 3 }]
            starter_box << ["Type \nUsed", "Weight\n (g)", "Freezer \n °C", "Type\n Used", "Weight\n (g)", "Chiller \n °C"]
            starter_box << [
              makesheet.type_of_starter_culture_used.to_s,
              makesheet.qty_of_starter_used ? sprintf('%.3f', makesheet.qty_of_starter_used) : '',
              makesheet.freezer_temp,
              makesheet.rennet_used,
              makesheet.rennet_weight_used,
              makesheet.chiller_temp
            ]

            pdf.table(starter_box) do
              self.width = 240
              self.cell_style = { inline_format: true }
              self.column_widths = [40, 40, 40, 40, 40, 40]

              row(0).background_color = "D3D3D3"
              rows(0..2).align = :center
              rows(0).size = 7
              rows(1).size = 6
              rows(2).size = 8
              rows(2).height = 24
              row(-1).font_style = :bold
              self.cell_style = {
                inline_format: true,
                borders: [:top, :left, :bottom, :right],
                border_width: 1,
                border_color: "000000"
              }
            end
          end
    # END STARTER SET ********************************************************************************

           pdf.text "\n", size: 6
                   
           weather_box = Array.new
           weather_box << ["<b>WEATHER TODAY</b>", "<b>Temp oC</b>", "<b>Humidity</b>"]
           weather_box << ["#{makesheet.weather_today}","#{makesheet.weather_temp}","#{makesheet.weather_humidity}"]
           
           pdf.table(weather_box)  do 
                    self.width = 200
                     self.cell_style = { :inline_format => true } 
                     {:borders => [:top, :left, :bottom, :right],
                     :border_width => 1,
                     :border_color => "B2BEB5",}
                     columns(0).width = 100
                     columns(1..2).width = 50
                     row(0).background_color = "D3D3D3"
                     rows(0..1).align = :center
                     rows(0).size = 7
                     rows(1).size = 9
                     
                   end  
    # END WEATHER ********************************************************************************

    pdf.text "\n", size: 6

        # --------------------------
        # data
        # --------------------------
        yn       = makesheet.pre_start_inspection_of_high_risk_items
        yes_val  = yn ? "YES" : ""
        no_val   = yn ? ""    : "YES"

        checked_by_1 = Staff.find_by(id: makesheet.pre_start_inspection_by_staff_id)&.full_name.to_s
        checked_by_2 = Staff.find_by(id: makesheet.pre_start_inspection_by_2_staff_id)&.full_name.to_s

        high_risk_box = []
        high_risk_box << [{ content: "<b>PRE-START INSPECTION OF HIGH RISK ITEMS</b>", colspan: 3 }]
        high_risk_box << [{ content: "ALL HIGH RISK GLASS/BRITTLE MATERIAL AND METAL ITEMS INSPECTED PRIOR TO USE - ARE THEY IN GOOD CONDITION?", colspan: 3 }]
        high_risk_box << ["<b>#{yes_val}", "#{no_val}</b>", "IF NOT IN GOOD CONDITION, RECORD ACTIONS IN COMMENTS"]
        high_risk_box << [
          { content: "CHECKED BY:", colspan: 2 },
          { content: "<b>#{checked_by_1} - #{checked_by_2}</b>", colspan: 2 }
        ]

        # --------------------------
        # table
        # --------------------------
        pdf.table(high_risk_box) do
          self.width = 240
          self.cell_style = { inline_format: true }

          # --------------------------
          # formatting
          # --------------------------
          cells.borders = [:top, :left, :bottom, :right]
          cells.border_width = 1
          #cells.border_color = "B2BEB5"
          row(0).text_color = "FF0000"   # 🔴 red font

          # columns: two narrow for YES/NO, one wide for comments
          columns(0).width = 34
          columns(1).width = 34
          columns(2).width = (self.width - 68)

          # header row
          row(0).align = :center
          row(0).size  = 8
          row(0).background_color = "E0E0E0"

          # comment/instruction row
          row(1).align = :center
          row(1).size  = 6
          row(1).background_color = "EEEEEE"

          # YES/NO values row
          row(2).columns(0..1).size = 9
          row(2).columns(2).size = 7
          row(2).columns(0..1).align = :center
          row(2).columns(2).align    = :left   # free-text comments area

          # CHECKED BY row
          row(3).size = 8
          row(3).columns(0).align = :left
          row(3).columns(1..2).align = :left
        end

    # END PRE START INSPECTION *********************************
                   
             pdf.text "\n", size: 6

             ib_change_box = Array.new
             ib_change_box << ["<b>INGREDIENT BATCH CHANGE</b>"]
             ib_change_box << ["<font size='7'>#{truncate(makesheet.ingredient_batch_change.present? ? makesheet.ingredient_batch_change : "NO", length:50)}"]

                    pdf.table(ib_change_box)  do 
                      self.width = 200
                       self.cell_style = { :inline_format => true} 
                       {:borders => [:top, :left, :bottom, :right],
                       :border_width => 1,
                       :border_color => "B2BEB5",}
                       columns(0).width = 200
                       row(0).background_color = "D3D3D3"
                       rows(0..1).align = :center
                       rows(0).size = 7
                       rows(1).size = 12
                     end  
                     
        # END OF INGREDIENT  BATCH CHANGE  ******************************************************************************         
        pdf.text "\n", size: 6        

                     thermo_box = []
                     thermo_box << ["<b>THERMOMETER CHANGE</b>", "<b>SCALE CHANGE</b>"]
                     thermo_box << [
                       "<font size='7'>#{truncate(makesheet.thermometer_change.presence || 'NO', length: 44)}</font>",
                       "<font size='7'>#{truncate(makesheet.scale_change.present? ? makesheet.scale_change : "NO", length:44)}</font>"
                     ]
                      pdf.table(thermo_box)  do 
                        self.width = 200
                         self.cell_style = { :inline_format => true } 
                         {:borders => [:top, :left, :bottom, :right],
                         :border_width => 1,
                         :border_color => "B2BEB5",}
                         columns(0).width = 100
                         row(0).background_color = "D3D3D3"
                         rows(0..1).align = :center
                         rows(0).size = 6
                         rows(1).size = 8
                        end   
 # END OF THERMO CHANGE ******************************************************************************         

              pdf.text "\n", size: 6       
              notes_box = Array.new
              notes_box << ["<b>POST MAKE NOTES</b>"]
              notes_box << ["Batch Dipped?:       #{makesheet.batch_dipped == true ? "YES":  (makesheet.batch_dipped.nil? ? "" : "NO")}"]
              notes_box << ["#{makesheet.post_make_notes}"]
              

              pdf.table(notes_box)  do 
                self.width = 200
                 self.cell_style = { :inline_format => true, size: 8  } 
                 {:borders => [:top, :left, :bottom, :right],
                 :border_width => 1,
                 :border_color => "B2BEB5",}
                 columns(0).width = 200
                 row(0).background_color = "D3D3D3"
                 rows(0).align = :center
                 rows(0).size = 7
                 rows(1).size = 8
                 rows(2).height = 34
                end 
                       
     # END OF POST MAKE NOTES  ******************************************************************************         
               pdf.text "\n", size: 6

               sign_box = Array.new
               assistant = Staff.find_by(id: makesheet.assistant_staff_id)
               sign_box << ["<b>CHEESE MADE BY:</b>", "<b>MILLING HELP</b>"]
               sign_box << [
                  "<font size='10'>#{makesheet.cheese_made_by_staff&.full_name}</font><br/><font size='8'>#{assistant&.full_name}</font>",
                  "<font size='8'>#{makesheet.milling_help}</font>"
                ]

                      pdf.table(sign_box)  do 
                        self.width = 200
                         self.cell_style = { :inline_format => true, size: 10, :height => 70 } 
                         {:borders => [:top, :left, :bottom, :right],
                         :border_width => 1,
                         :border_color => "B2BEB5",}
                         columns(0).width = 140
                         columns(1).width = 60
                         rows(0).background_color = "D3D3D3"
                         rows(0).height = 18
                         rows(1).height = 30
                         rows(0..1).align = :center
                         rows(0).size = 7
                         row(1).size = 9
                         
                        end  
     end
     
     pdf.grid(0, 2).bounding_box do
      
       pdf.text "\n", size: 12       
       weight_box = Array.new
       weight_box << ["<b>WEIGHT</b>", "<b>YIELD (%)</b>"]
       weight_box << ["#{makesheet.total_weight}", "#{makesheet.yield.round(2)}"]

              pdf.table(weight_box)  do 
                self.width = 252
                 self.cell_style = { :inline_format => true} 
                 {:borders => [:top, :left, :bottom, :right],
                 :border_width => 1,
                 :border_color => "B2BEB5",}
                 columns(0).width = 126
                 columns(1).width = 126
                 rows(0).background_color = "D3D3D3"
                 rows(0..1).align = :center
                 rows(0).size = 7
                 rows(1).size = 12
                  end    
                  
       # Determine active column index based on weight_type
        weight_col_index =
        case makesheet.weight_type
        when "Standard (20 kgs)" then 0
        when "Midi (8 kgs)"      then 1
        when "2.5kg"             then 2
        else nil
        end

        # Determine if we should show labels or not
        has_values = makesheet.number_of_cheeses.present? || makesheet.total_weight.present?
        show_labels = weight_col_index.nil? || !has_values

        # Header row
        number_box = []
        number_box << ["Standard (20kg)", "Midi (8kg)", "2.5kg"]

        # Second row — show "Number" labels or actual values
        number_row = Array.new(3, "")
        weight_row = Array.new(3, "")

        if show_labels
        number_row = ["Number", "Number", "Number"]
        weight_row = ["Weight", "Weight", "Weight"]
        else
          number_row[weight_col_index] = "<font size='9'><b>#{makesheet.number_of_cheeses}</b></font>" if makesheet.number_of_cheeses.present?
          weight_row[weight_col_index] = "<font size='9'><b>#{makesheet.total_weight} kg</b></font>" if makesheet.total_weight.present?
            end

        number_box << number_row
        number_box << weight_row

            # Draw the section heading
            pdf.text "\n", size: 6
            pdf.table([["<b>NUMBER / SIZE & WEIGHT OF CHEESES MADE</b>"]]) do
              self.width = 252
              self.cell_style = {
                inline_format: true,
                borders: [:top, :bottom, :left, :right],
                border_width: 1,
                border_color: "000000"
              }
              row(0).background_color = "D3D3D3"
              row(0).align = :center
              row(0).size = 6
              #cells.style(border_color: "B2BEB5")
            end

            pdf.table(number_box) do
              self.width = 252
              self.cell_style = {
                inline_format: true,
                borders: [:top, :bottom, :left, :right],
                border_width: 1,
                border_color: "000000"
              }
              row(0).background_color = "D3D3D3"
              rows(0..2).align = :center
              row(0).size = 7
              rows(1..2).size = 6

               # 👇 make placeholder labels lighter only when they’re shown
              if show_labels
                rows(1..2).text_color = "9E9E9E"   # light gray (tweak: "A0A0A0" / "B0B0B0" / "C0C0C0")
              else
                rows(1..2).text_color = "000000"   # ensure real values stay black
              end
            end


            
            pdf.text "\n", size: 6        
            salt_header_box = Array.new
            salt_header_box << ["<b>SALT ADDITION </b>- 2% EXPECTED CURD WEIGHT"]
        
                   pdf.table(salt_header_box)  do 
                     self.width = 252
                      self.cell_style = { :inline_format => true, :size => 10, :height => 20 } 
                      {:borders => [:top, :left, :bottom, :right],
                      :border_width => 1,
                      :border_color => "B2BEB5",}
                      rows(0).background_color = "D3D3D3"
                      rows(0).align = :center
                      rows(0).size = 7
                       end    
                   
             salt_box = Array.new
             salt_box << ["MILK (Ltrs,00's)", "EXPECTED YIELD (%)", "SALT(KG)(NET/GROSS)"]
             salt_box << ["#{makesheet.milk_used}", "#{makesheet.yield.round(1)}", "#{makesheet.salt_weight_net} / #{makesheet.salt_weight_gross}"]
           
                    pdf.table(salt_box)  do 
                      self.width = 252
                       self.cell_style = { :inline_format => true, :size => 10, :height => 22 } 
                       {:borders => [:top, :left, :bottom, :right],
                       :border_width => 1,
                       :border_color => "B2BEB5",}
                       rows(0).background_color = "D3D3D3"
                       rows(0..1).align = :center
                       rows(0).size = 7
                       rows(1).size = 10
                       rows(2).size = 20 
                   end     
                
                pdf.text "\n", size: 6         
                glass_breakage_box = Array.new
                glass_breakage_box << [
                  "<color rgb='0000CC'><b>ANY GLASS AND/OR BRITTLE MATERIAL BREAKAGES DURING MAKE?</b></color>"
                ]
                glass_breakage_box << [
                  "<color rgb='FF0000'><b>HIGH RISK ITEMS INCLUDE:</b></color> BURETTE, SIEVES, LIGHTS OVER VAT AND PRESS PRESSURE GAUGE DIALS"
                ]
                       pdf.table(glass_breakage_box)  do 
                         self.width = 252
                          self.cell_style = { :inline_format => true, :size => 7 } 
                          {:borders => [:top, :left, :bottom, :right],
                          :border_width => 1,
                          :border_color => "B2BEB5",}
                          rows(0).background_color = "D3D3D3"
                          rows(0).align = :center
                          rows(0).size = 7
                           end    
                        
                        glass_details_line = Array.new
                        glass_details_line <<["<b>#{makesheet.glass_breakage == true ? "YES" : ""}</b>", "RECORD ACTIONS TAKEN BELOW", "<b>#{makesheet.glass_breakage == false ? "NO" : ""}</b>"]
                          
                pdf.table(glass_details_line)  do 
                    self.width = 252
                      self.cell_style = { :inline_format => true, :size => 7, :height => 24 } 
                    {:borders => [:top, :left, :bottom, :right],
                    :border_width => 1,
                    :border_color => "B2BEB5",}
                    columns(0).size = 8
                    columns(1).size = 7
                    columns(2).size = 8
                    rows(0).align = :center
                    columns(0).width = 30
                    columns(1).width = 192
                    columns(2).width = 30
                end
          
                contamination_title_box = Array.new
                contamination_title_box << ["<b>IF 'YES', HAS PRODUCT BEEN CONTAMINATED?</b>"]
              
                      pdf.table(contamination_title_box)  do 
                        self.width = 252
                          self.cell_style = { :inline_format => true, :size => 7 } 
                          {:borders => [:top, :left, :bottom, :right],
                          :border_width => 1,
                          :border_color => "B2BEB5",}
                          rows(0).background_color = "D3D3D3"
                          rows(0).align = :center
                          rows(0).size = 7
                end    
                
                contamination_details_box = Array.new
                contamination_details_box <<["<b>#{makesheet.glass_contamination == true ? "YES" : ""}</b>", "IF YES, FOLLOW W1 02,PUT HOLD, COMPLETE FB INVESTIGATION SUMMARY FORM AND EMAIL TIM", "<b>#{makesheet.glass_contamination == false ? "NO" : ""}</b>"]
            
                      pdf.table(contamination_details_box)  do 
                          self.width = 252
                            self.cell_style = { :inline_format => true, :size => 7, :height => 30 } 
                          {:borders => [:top, :left, :bottom, :right],
                          :border_width => 1,
                          :border_color => "B2BEB5",}
                          columns(0).size = 8
                          columns(1).size = 7
                          columns(2).size = 8
                          rows(0).align = :center
                          columns(0).width = 30
                          columns(1).width = 192
                          columns(2).width = 30
                  end
                  
                  pdf.text "\n", size: 8         
                  metal_breakage_box = Array.new
                  metal_breakage_box << [
                    "<color rgb='0000CC'><b>ANY METAL BREAKAGES DURING MAKE?</b></color>"
                  ]
                  metal_breakage_box << [
                  "<color rgb='FF0000'><b>HIGH RISK ITEMS INCLUDE:</b></color> MILL, MILL BLADES AND KNIFE TIPS"
                ]

        pdf.table(metal_breakage_box)  do 
          self.width = 252
            self.cell_style = { :inline_format => true, :size => 7 } 
            {:borders => [:top, :left, :bottom, :right],
            :border_width => 1,
            :border_color => "B2BEB5",}
            rows(0).background_color = "D3D3D3"
            rows(0).align = :center
            rows(0).size = 7
            end    

          metal_details_line = Array.new
          metal_details_line <<["<b>#{makesheet.metal_breakage== true ? "YES" : ""}</b>", "RECORD ACTIONS TAKEN BELOW", "<b>#{makesheet.metal_breakage == false ? "NO" : ""}</b>"]

              pdf.table(metal_details_line)  do 
                  self.width = 252
                    self.cell_style = { :inline_format => true, :size => 7, :height => 24 } 
                    {:borders => [:top, :left, :bottom, :right],
                    :border_width => 1,
                    :border_color => "B2BEB5",}
                    columns(0).size = 8
                    columns(1).size = 7
                    columns(2).size = 8
                    rows(0).align = :center
                    columns(0).width = 30
                    columns(1).width = 192
                    columns(2).width = 30
                        end

              contamination_title_box = Array.new
              contamination_title_box << ["<b>IF 'YES', HAS PRODUCT BEEN CONTAMINATED?</b>"]

                  pdf.table(contamination_title_box)  do 
                    self.width = 252
                    self.cell_style = { :inline_format => true, :size => 6 } 
                    {:borders => [:top, :left, :bottom, :right],
                    :border_width => 1,
                    :border_color => "B2BEB5",}
                    rows(0).background_color = "D3D3D3"
                    rows(0).align = :center
                      rows(0).size = 7
                end    

                contamination_details_box = Array.new
                contamination_details_box <<["<b>#{makesheet.metal_contamination == true ? "YES" : ""}</b>", "IF YES, FOLLOW W1 02,PUT HOLD, COMPLETE FB INVESTIGATION SUMMARY FORM AND EMAIL TIM", "<b>#{makesheet.metal_contamination == false ? "NO" : ""}</b>"]

                    pdf.table(contamination_details_box)  do 
                        self.width = 252
                          self.cell_style = { :inline_format => true, :size => 7, :height => 30 } 
                          {:borders => [:top, :left, :bottom, :right],
                          :border_width => 1,
                          :border_color => "B2BEB5",}
                          columns(0).size = 8
                        columns(1).size = 7
                        columns(2).size = 8
                        rows(0).align = :center
                        columns(0).width = 30
                        columns(1).width = 192
                        columns(2).width = 30
    
                    end
                    
                    pdf.text "\n", size: 6         
                    comments_box = Array.new
                    comments_box << ["<b>COMMENTS AND CORRECTIVE ACTIONS</b>"]
                    comments_box << ["#{makesheet.metal_comments}""\n""#{makesheet.glass_comments}"]

                      pdf.table(comments_box)  do 
                        self.width = 252
                        self.cell_style = { :inline_format => true } 
                        {:borders => [:top, :left, :bottom, :right],
                        :border_width => 1,
                        :border_color => "B2BEB5",}
                        columns(0).width = 252
                        row(0).background_color = "D3D3D3"
                        rows(0).align = :center
                        rows(0).size = 7
                        rows(1).size = 20
                        end 
                        pdf.text "Page: 1 - Ref: CD01", size: 8, align: :right
     end
     
  end
end