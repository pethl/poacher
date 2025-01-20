class MakesheetsController < ApplicationController
  require_relative Rails.root.join('services/weather_service')
  before_action :authenticate_user!
  before_action :set_makesheet, only: %i[ show edit update destroy batch_turns]

  def makesheet_search
    if params[:search_by_batch] && params[:search_by_batch] != ""
      @makesheets = Makesheet.where(batch: params[:search_by_batch])
    end 
  end

  def overview
  end  
  
  def batch_turns
    @turns = @makesheet.turns.ordered
    @batch_turns_graph_data = get_data(@makesheet)
  end

  def graded_blackboard
    @makesheets = Makesheet.where("status NOT IN (?)", "Finished").where("grade <> ''").order("grade ASC, make_date ASC")
    @makesheets_by_grade = @makesheets.group_by { |t| t.grade }
  end

  def monthly_summary 
    
    if params[:month].present? && params[:year].present?
      @makesheets = Makesheet.filter_by_month_and_year(params[:month], params[:year])
     
    else
      @makesheets = Makesheet.where('make_date BETWEEN ? AND ?', Date.today.beginning_of_month, Date.today.end_of_month).ordered
    end 

      @total_monthly_milk_litres =  @makesheets.pluck(:milk_used).compact.sum

      @large_poacher_count =  @makesheets.where(weight_type: "Standard (20 kgs)").where(make_type: "Normal").pluck(:number_of_cheeses).compact.sum
      @large_poacher_weight =  @makesheets.where(weight_type: "Standard (20 kgs)").where(make_type: "Normal").pluck(:total_weight).compact.sum

      @red_poacher_count =  @makesheets.where(weight_type: "Standard (20 kgs)").where(make_type: "Red").pluck(:number_of_cheeses).compact.sum
      @red_poacher_weight =  @makesheets.where(weight_type: "Standard (20 kgs)").where(make_type: "Red").pluck(:total_weight).compact.sum

      @medium_cheese_count =  @makesheets.where(weight_type: "Midi (8 kgs)").pluck(:number_of_cheeses).compact.sum
      @medium_cheese_weight = @makesheets.where(weight_type: "Midi (8 kgs)").pluck(:total_weight).compact.sum

      @small_cheese_count =  @makesheets.where(weight_type: "2.5kg").pluck(:number_of_cheeses).compact.sum
      @small_cheese_weight = @makesheets.where(weight_type: "2.5kg").pluck(:total_weight).compact.sum

      @data = @makesheets.ordered.pluck(:make_date, :milk_used, :weather_today).map do |make_date, milk_used, weather_today|
        [make_date&.strftime("%-d"), milk_used, weather_today] if make_date.present?
      end.compact

     
  end
  
  
  # GET /makesheets or /makesheets.json
  def index
     if params[:column].present?
         @makesheets = Makesheet.order("#{params[:column]} #{params[:direction]}")
       else
         @makesheets = Makesheet.all.ordered_reverse
       end
  end

  # GET /makesheets/1 or /makesheets/1.json
  def show
    @samples = Sample.where(makesheet_id: @makesheet.id)
  end

  # GET /makesheets/new
  def new
    @makesheet = Makesheet.new
    @staffs = Staff.ordered

     #no need to define location as its hard coded in service
     service = WeatherService.new
     @weather = service.fetch_daily_weather
 
     if @weather[:error]
       flash[:alert] = @weather[:error]
       @weather = nil
     end
     @makesheet.weather_today = @weather[:conditions]
     @makesheet.weather_temp = @weather[:temperature]
     @makesheet.weather_humidity = @weather[:humidity]
     
 
  end

  # GET /makesheets/1/edit
  def edit
    @staffs = Staff.ordered
  end

  # POST /makesheets or /makesheets.json
  def create
    @makesheet = Makesheet.new(makesheet_params)
    @staffs = Staff.ordered
    @makesheet.batch = (@makesheet.make_date + 6.years).to_formatted_s  .strftime("%d-%m-%y")

    respond_to do |format|
      if @makesheet.save
        format.html { redirect_to makesheet_url(@makesheet), notice: "Makesheet was successfully created." }
        format.json { render :show, status: :created, location: @makesheet }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @makesheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /makesheets/1 or /makesheets/1.json
  def update
    @staffs = Staff.ordered
    respond_to do |format|
      if @makesheet.update(makesheet_params)
        format.html { redirect_to makesheet_url(@makesheet), notice: "Makesheet was successfully updated." }
        format.json { render :show, status: :ok, location: @makesheet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @makesheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /makesheets/1 or /makesheets/1.json
  def destroy
    @makesheet.destroy

    respond_to do |format|
      format.html { redirect_to makesheets_url, notice: "Makesheet was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  def print_makesheet_pdf
      raleway_font_path = 'app/assets/fonts/raleway/Raleway-Medium.ttf'
      raleway_bold_font_path = 'app/assets/fonts/raleway/Raleway-Bold.ttf'
      logo_img_path = 'app/assets/images/poacher_logo.jpeg'
  
      pdf = Prawn::Document.new(:page_size => "A4", :page_layout => :landscape)
      pdf.font_families.update(
        'raleway' => {
          normal: raleway_font_path, # Path to the normal (regular) font style
          bold: raleway_bold_font_path # Path to the bold font style (if applicable)
        }
      )
      pdf.font "raleway"
    
      @makesheet = Makesheet.find(params[:id])
    
       pdf.text "LINCOLNSHIRE POACHER - MAKE SHEET", size: 10, style: :bold, align: :right
       pdf.text "\n", size: 8  

       pdf.define_grid(columns: 3, rows: 1, gutter: 6)
       pdf.grid(0, 0).bounding_box do
         date_box = Array.new
         date_box << ["Date:", "<b>#{@makesheet.make_date&.strftime('%b %d, %Y')}</b>"]
      
                pdf.table(date_box) do 
                  self.width = 210
                   self.cell_style = { :inline_format => true, size: 10 } 
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
                 pdf.text "\n", size: 8  
         
                 first_column = Array.new 
                 first_column << ["", "<b>TIME</b>", "<b>TEMP (°C)</b>"]
                 first_column << ["BOILER ON",  "#{@makesheet.boiler_on_time&.strftime('%I:%M %p')}", ""]
                 first_column << ["STEAM / HOT WATER ON", "#{@makesheet.steam_hot_water_on_time&.strftime('%I:%M %p')}", ""]
                 first_column << ["COLD MILK IN RECORD AS 'OK' IF < 4°C", "#{@makesheet.cold_milk_in_time&.strftime('%I:%M %p')}", "#{@makesheet.cold_milk_in_state}"]
                 first_column << ["WARM MILK FINISH",  "#{@makesheet.warm_milk_finish_time&.strftime('%I:%M %p')}", "#{@makesheet.warm_milk_finish_titration}"]
                 first_column << ["STARTER IN",  "#{@makesheet.starter_in_time&.strftime('%I:%M %p')}", "#{@makesheet.starter_in_temp}"]
                 first_column << ["HEAT OFF", "#{@makesheet.heat_off_1_time&.strftime('%I:%M %p')}", "#{@makesheet.heat_off_1_temp}"]
                 first_column << ["MILK TITRATION", "#{@makesheet.milk_titration_time&.strftime('%I:%M %p')}", "#{@makesheet.milk_titration_temp}"]
                 first_column << ["RENNET", "#{@makesheet.rennet_time&.strftime('%I:%M %p')}", "#{@makesheet.rennet_temp}"]
                 first_column << ["CUT", "#{@makesheet.cut_start_time&.strftime('%I:%M %p')}", "#{@makesheet.cut_end_time&.strftime('%I:%M %p')}"]
                 first_column << ["HEAT ON", "#{@makesheet.heat_on_time&.strftime('%I:%M %p')}", ""]
                 first_column << ["HEAT OFF", "#{@makesheet.heat_off_2_time&.strftime('%I:%M %p')}", "#{@makesheet.heat_off_2_temp}"]
                 first_column << ["PITCH", "#{@makesheet.pitch_time&.strftime('%I:%M %p')}", "<sup>Titration</sup>"]
                 first_column << ["WHEY", "#{@makesheet.whey_time&.strftime('%I:%M %p')}", "#{@makesheet.whey_titration}"]
                 first_column << ["1ST CUT","#{@makesheet.first_cut_time&.strftime('%I:%M %p')}", "#{@makesheet.first_cut_titration}"]
                 first_column << ["2ND CUT", "#{@makesheet.second_cut_time&.strftime('%I:%M %p')}", "#{@makesheet.second_cut_titration}"]
                 first_column << ["3RD CUT","#{@makesheet.third_cut_time&.strftime('%I:%M %p')}", "#{@makesheet.third_cut_titration}"]
                 first_column << ["MILL\nXXXXXX MILL USED", "#{@makesheet.identify_mill_used}", ""]
        
                      pdf.table(first_column) do 
                        self.width = 210
                         self.cell_style = { :inline_format => true, size: 10, :height => 24   } 
                         {:borders => [:top, :left, :bottom, :right],
                         :border_width => 1,
                         :border_color => "B2BEB5",}
                         cells[1, 2].background_color = 'D3D3D3' 
                         cells[2, 2].background_color = 'D3D3D3' 
                         cells[10, 2].background_color = 'D3D3D3' 
                         cells[12, 2].background_color = 'D3D3D3' 
                         columns(0).width = 100
                         columns(1).width = 55
                         columns(2).width = 55
                         row(0).background_color = "D3D3D3"
                         columns(0).align = :center
                         rows(0).size = 7
                         columns(1..2).align = :center
                        
                         columns(0).size = 7
                         columns(2).size = 9
                       end
       end
       
       pdf.grid(0, 1).bounding_box do
        pdf.text "\n", size: 14

         milk_box = Array.new
         milk_box << ["<b>MILK USED</b>","", "","","Bottles (back from F/Mkts)"]
         milk_box << ["Warm am","12 hr pm", "Record unusual smell or visual appearance","Number","U/B Date"]
         milk_box << ["<b>#{@makesheet.warm_am == true ? "YES":  (@makesheet.warm_am.nil? ? "" : "NO")}","<b>#{@makesheet.twelve_hr_pm == true ? "YES":  (@makesheet.twelve_hr_pm.nil? ? "" : "NO")}", "<b>#{@makesheet.unusual_smell_appearance}","<b>#{@makesheet.number_of_bottles_from_fm}","<b>#{@makesheet.use_by_date_milk_from_fm&.strftime('%d-%m-%y')}</b>"]
        
                pdf.table(milk_box)  do 
                  self.width = 250
                   self.cell_style = { :inline_format => true, size: 10, :height => 22 } 
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
                   rows(1).size = 6
                   rows(2).size = 9
                   #columns(0..4).size = 7
                 end
                 
           pdf.text "\n", size: 8   
            
           starter_box = Array.new
           starter_box << ["<b>STARTER CULTURE USED</b>",""]
           starter_box << ["Type of Starter Culture Used","Qty Used"]
           starter_box << ["#{@makesheet.type_of_starter_culture_used}","#{@makesheet.qty_of_starter_used}"]
  
                  pdf.table(starter_box)  do 
                    self.width = 200
                     self.cell_style = { :inline_format => true } 
                     {:borders => [:top, :left, :bottom, :right],
                     :border_width => 1,
                     :border_color => "B2BEB5",}
                     columns(0).width = 120
                     columns(1).width = 80
                     row(0).background_color = "D3D3D3"
                     rows(0..2).align = :center
                     rows(0).size = 7
                     rows(1).size = 6
                     rows(2).size = 12
                     rows(2).height = 30
                   end      
             
             pdf.text "\n", size: 8
                     
             weather_box = Array.new
             weather_box << ["<b>WEATHER TODAY</b>", "<b>Temp oC</b>", "<b>Humidity</b>"]
             weather_box << ["#{@makesheet.weather_today}","#{@makesheet.weather_temp}","#{@makesheet.weather_humidity}"]
             
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
                       rows(1).size = 12 
                       
                     end  
                     
               pdf.text "\n", size: 8         
               ib_change_box = Array.new
               ib_change_box << ["<b>INGREDIENT BATCH CHANGE</b>"]
               ib_change_box << ["#{@makesheet.ingredient_batch_change ? "YES" : "NO"}"]

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
                       
                 pdf.text "\n", size: 8         
                 thermo_box = Array.new
                 thermo_box << ["<b>THERMOMETER CHANGE</b>", "<b>SCALE CHANGE</b>"]
                 thermo_box << ["#{@makesheet.thermometer_change ? "YES" : "NO"}", "#{@makesheet.scale_change ? "YES" : "NO"}"]

                        pdf.table(thermo_box)  do 
                          self.width = 200
                           self.cell_style = { :inline_format => true } 
                           {:borders => [:top, :left, :bottom, :right],
                           :border_width => 1,
                           :border_color => "B2BEB5",}
                           columns(0).width = 100
                           row(0).background_color = "D3D3D3"
                           rows(0..1).align = :center
                           rows(0).size = 7
                           rows(1).size = 12
                          end   
                          
                pdf.text "\n", size: 8         
                notes_box = Array.new
                notes_box << ["<b>POST MAKE NOTES</b>"]
                notes_box << ["Batch Dipped?:       #{@makesheet.batch_dipped == true ? "YES":  (@makesheet.batch_dipped.nil? ? "" : "NO")}"]
                notes_box << ["#{@makesheet.post_make_notes}"]
                

                pdf.table(notes_box)  do 
                  self.width = 200
                   self.cell_style = { :inline_format => true } 
                   {:borders => [:top, :left, :bottom, :right],
                   :border_width => 1,
                   :border_color => "B2BEB5",}
                   columns(0).width = 200
                   row(0).background_color = "D3D3D3"
                   rows(0).align = :center
                   rows(0).size = 7
                   rows(1).size = 10
                   rows(2).height = 80
                  end 
                         
                 pdf.text "\n", size: 8         
                 sign_box = Array.new
                 sign_box << ["<b>CHEESE MADE BY:</b>", "<b>MILLING HELP</b>"]
                 sign_box << ["#{@makesheet.cheese_made_by_staff&.full_name || ""}", "#{@makesheet.milling_help}"]

                        pdf.table(sign_box)  do 
                          self.width = 200
                           self.cell_style = { :inline_format => true, size: 10, :height => 70 } 
                           {:borders => [:top, :left, :bottom, :right],
                           :border_width => 1,
                           :border_color => "B2BEB5",}
                           columns(0).width = 140
                           columns(1).width = 60
                           rows(0).background_color = "D3D3D3"
                           rows(0).height = 20
                           rows(1).height = 50
                           rows(0..1).align = :center
                           rows(0).size = 7
                           row(1).size = 12
                           
                          end  
       end
       
       pdf.grid(0, 2).bounding_box do
        
         pdf.text "\n", size: 14       
         weight_box = Array.new
         weight_box << ["<b>WEIGHT</b>", "<b>YIELD (%)</b>"]
         weight_box << ["#{@makesheet.total_weight}", "#{@makesheet.yield.round(2)}"]

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
                    
          pdf.text "\n", size: 6         
          number_header_box = Array.new
          number_header_box << ["<b>NUMBER / SIZE & WEIGHT OF CHEESES MADE</b>"]
          
                 pdf.table(number_header_box)  do 
                   self.width = 252
                    self.cell_style = { :inline_format => true} 
                    {:borders => [:top, :left, :bottom, :right],
                    :border_width => 1,
                    :border_color => "B2BEB5",}
                    rows(0).background_color = "D3D3D3"
                    rows(0).align = :center
                    rows(0).size = 6
                end    
                     
           number_box = Array.new
           number_box << ["Standard (20kg)", "Midi (8kg)", "2.5kg"]
           number_box << ["Number", "Number", "Number"]
           number_box << ["Weight", "Weight", "Weight"]

                  pdf.table(number_box)  do 
                    self.width = 252
                     self.cell_style = { :inline_format => true} 
                     {:borders => [:top, :left, :bottom, :right],
                     :border_width => 1,
                     :border_color => "B2BEB5",}
                     rows(0).background_color = "D3D3D3"
                     rows(0).align = :center
                     rows(0).size = 7
                     rows(1..2).size = 6
                    # rows(1).height = 12
                    # rows(1..2).size = 5
                    # rows(1..2).height = 14
                     
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
               salt_box << ["#{@makesheet.milk_used}", "#{@makesheet.yield.round(1)}", "#{@makesheet.salt_weight_net} / #{@makesheet.salt_weight_gross}"]
             
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
                  glass_breakage_box << ["<b>ANY GLASS AND/OR BRITTLE MATERIAL BREAKAGES DURING MAKE?</b>"]
                  glass_breakage_box << ["<b>HIGH RISK ITEMS INCLUDE:</b> BURETTE, SIEVES, LIGHTS OVER VAT AND PRESS PRESSURE GUAGE DIALS"]
                 
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
                          glass_details_line <<["<b>#{@makesheet.glass_breakage == true ? "YES" : ""}</b>", "RECORD ACTIONS TAKEN BELOW", "<b>#{@makesheet.glass_breakage == false ? "NO" : ""}</b>"]
                            
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
                               contamination_title_box << ["<b>HAS PRODUCT BEEN CONTAMINATED?</b>"]
                              
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
                                contamination_details_box <<["<b>#{@makesheet.glass_contamination == true ? "YES" : ""}</b>", "IF YES, FOLLOW W1 02,PUT HOLD, COMPLETE FB INVESTIGATION SUMMARY FORM AND EMAIL TIM", "<b>#{@makesheet.glass_contamination == false ? "NO" : ""}</b>"]
                            
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
                                 metal_breakage_box << ["<b>ANY METAL BREAKAGES DURING MAKE?</b>"]
                                 metal_breakage_box << ["<b>HIGH RISK ITEMS INCLUDE:</b> MILL, MILL BLADES AND KNIFE TIPS"]
                 
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
            metal_details_line <<["<b>#{@makesheet.metal_breakage== true ? "YES" : ""}</b>", "RECORD ACTIONS TAKEN BELOW", "<b>#{@makesheet.metal_breakage == false ? "NO" : ""}</b>"]

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
                contamination_title_box << ["<b>HAS PRODUCT BEEN CONTAMINATED?</b>"]

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
                  contamination_details_box <<["<b>#{@makesheet.metal_contamination == true ? "YES" : ""}</b>", "IF YES, FOLLOW W1 02,PUT HOLD, COMPLETE FB INVESTIGATION SUMMARY FORM AND EMAIL TIM", "<b>#{@makesheet.metal_contamination == false ? "NO" : ""}</b>"]

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
                      comments_box << ["#{@makesheet.metal_comments}""\n""#{@makesheet.glass_comments}"]

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
                          rows(1).size = 9
                          end   
       end
                       
        #   pdf.image logo_img_path, :at => [482,742], :width => 80 
           send_data pdf.render, filename: 'make_sheet.pdf', type: 'application/pdf', :disposition => 'inline'
  end
   
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_makesheet
      @makesheet = Makesheet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def makesheet_params
      params.require(:makesheet).permit(:status, :make_date, :make_type, 
      :milk_used, :total_weight, :number_of_cheeses, :weight_type, :grade,
      :boiler_on_time, :steam_hot_water_on_time, :cold_milk_in_time, :cold_milk_in_state, :warm_milk_finish_time, :warm_milk_finish_titration, 
      :starter_in_time, :starter_in_temp, :heat_off_1_time, :heat_off_1_temp, :milk_titration_time, :milk_titration_temp, :rennet_time, :rennet_temp, 
      :cut_start_time, :cut_end_time, :heat_on_time, :heat_off_2_time, :heat_off_2_temp, :pitch_time, :whey_time, :whey_titration, 
      :first_cut_time, :first_cut_titration, :second_cut_time, :second_cut_titration, :third_cut_time, :third_cut_titration, :identify_mill_used, 
      :warm_am, :twelve_hr_pm, :unusual_smell_appearance, :number_of_bottles_from_fm, :use_by_date_milk_from_fm, 
      :type_of_starter_culture_used, :qty_of_starter_used, :pre_start_inspection_of_high_risk_items, :pre_start_inspection_by_staff_id, 
      :ingredient_batch_change, :thermometer_change, :scale_change, :batch_dipped, :post_make_notes, :milling_help, :cheese_made_by_staff_id, :salt_weight_net, :salt_weight_gross, 
      :weather_today, :weather_temp, :weather_humidity, :glass_breakage, :glass_contamination, :glass_comments, :metal_breakage, :metal_contamination, :metal_comments)
    end
    

    def get_data(makesheet)
      @age_counter = (Date.today.year * 12 + Date.today.month) - (makesheet.make_date.year * 12 + makesheet.make_date.month)
      @batch_turns_graph_data = Hash.new{|h,k| h[k] = [] }
      compare_date = makesheet.make_date
      
      while @age_counter>=0
        t_count = Turn.where(makesheet_id: makesheet).where('turn_date< ?', (compare_date)).count
        @batch_turns_graph_data.store(compare_date.to_formatted_s(:uk_m_y), t_count)
        @age_counter = @age_counter-1 
        compare_date = compare_date+1.month
      end
      # logger.debug "++++++++++count: #{@batch_turns_graph_data.inspect}"
      return @batch_turns_graph_data
    end


    def WeatherService
      include HTTParty
      base_uri 'http://api.weatherapi.com'
    
      def initialize
       
       # raise "Missing OpenWeather API Key" unless api_key
      end
    
      def fetch_weather
         @location = "LN130HE"
         @api_key = ENV.fetch['openweather_api_key'] # Store your API key in the environment
        options = { query: { q: @location, appid: @api_key, units: 'metric' } }
        response = self.class.get('/weather', options)
        parse_response(response)
      end
    
      private
    
      def parse_response(response)
        if response.success?
          {
            conditions: response['weather'].first['description'],
            temperature: response['main']['temp_c'],
            humidity: response['main']['humidity']
          }
        else
          { error: response['message'] }
        end
      end
    end
end
