class MakesheetsController < ApplicationController
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
    
      @makesheets = Makesheet.where("make_date >= ?", Date.today.at_beginning_of_month).ordered
      
      @total_monthly_milk_litres =  @makesheets.pluck(:milk_used).compact.sum

      @large_poacher_count =  @makesheets.where(weight_type: "Standard (20 kgs)").pluck(:number_of_cheeses).compact.sum
      @large_poacher_weight =  @makesheets.where(weight_type: "Standard (20 kgs)").pluck(:total_weight).compact.sum

     # @red_poacher_count =  Makesheet.where("make_date >= (?)", Date.today.at_beginning_of_month).where(weight_type: "Standard (20 kgs)").pluck(:number_of_cheeses).compact.sum
     # @red_poacher_weight =  Makesheet.where("make_date >= (?)", Date.today.at_beginning_of_month).where(weight_type: "Standard (20 kgs)").pluck(:total_weight).compact.sum

      @medium_cheese_count =  @makesheets.where(weight_type: "Midi (8 kgs)").pluck(:number_of_cheeses).compact.sum
      @medium_cheese_weight = @makesheets.where(weight_type: "Midi (8 kgs)").pluck(:total_weight).compact.sum

      @small_cheese_count =  @makesheets.where(weight_type: "2.5kg").pluck(:number_of_cheeses).compact.sum
      @small_cheese_weight = @makesheets.where(weight_type: "2.5kg").pluck(:total_weight).compact.sum

  end
  
  
  # GET /makesheets or /makesheets.json
  def index
     if params[:column].present?
         @makesheets = Makesheet.order("#{params[:column]} #{params[:direction]}")
       else
         @makesheets = Makesheet.all.ordered
       end
  end

  # GET /makesheets/1 or /makesheets/1.json
  def show
    @samples = Sample.where(make_date: @makesheet.make_date.to_s.split(' ').first)
  end

  # GET /makesheets/new
  def new
    @makesheet = Makesheet.new
  end

  # GET /makesheets/1/edit
  def edit
  end

  # POST /makesheets or /makesheets.json
  def create
    @makesheet = Makesheet.new(makesheet_params)

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
         date_box << ["Date: #{@makesheet.make_date.strftime('%b %d, %Y')}"]
      
                pdf.table(date_box) do 
                  self.width = 210
                   self.cell_style = { :inline_format => true, size: 10 } 
                   {:borders => [:top, :left, :bottom, :right],
                   :border_width => 1,
                   :border_color => "B2BEB5",}
                   columns(0).width = 210
                   rows(0).align = :left
                   columns(0).size = 7
                 end
                 pdf.text "\n", size: 8  
         
                 first_column = Array.new 
                 first_column << ["", "<b>TIME</b>", "<b>TEMP (°C)</b>"]
                 first_column << ["BOILER ON", "", ""]
                 first_column << ["STEAM / HOT WATER ON", "", ""]
                 first_column << ["COLD MILK IN RECORD AS 'OK' IF < 4°C", "", ""]
                 first_column << ["WARM MILK FINISH", "", "<sup>Titration</sup>"]
                 first_column << ["STARTER IN", "", ""]
                 first_column << ["HEAT OFF", "", ""]
                 first_column << ["MILK TITRATION", "", ""]
                 first_column << ["RENNET", "", ""]
                 first_column << ["CUT", "", ""]
                 first_column << ["HEAT ON", "", ""]
                 first_column << ["HEAT OFF", "", ""]
                 first_column << ["PITCH", "", "<sup>Titration</sup>"]
                 first_column << ["WHEY", "", ""]
                 first_column << ["1ST CUT", "", ""]
                 first_column << ["2ND CUT", "", ""]
                 first_column << ["3RD CUT", "", ""]
                 first_column << ["MILL\nXXXXXX MILL USED", "", ""]
        
                      pdf.table(first_column) do 
                        self.width = 210
                         self.cell_style = { :inline_format => true, size: 10, :height => 24   } 
                         {:borders => [:top, :left, :bottom, :right],
                         :border_width => 1,
                         :border_color => "B2BEB5",}
                         columns(0).width = 100
                         columns(1).width = 55
                         columns(2).width = 55
                         row(0).background_color = "D3D3D3"
                         columns(0).align = :center
                         rows(0).size = 7
                         columns(1..2).align = :center
                        
                         columns(0).size = 7
                         columns(2).size = 7
                       end
       end
       
       pdf.grid(0, 1).bounding_box do
         milk_box = Array.new
         milk_box << ["<b>MILK USED</b>","", "","","Bottles (back from F/Mkts)"]
         milk_box << ["Warm am","12 hr pm", "Record unusual smell or visual appearance","Number","U/B Date"]
         milk_box << ["","", "","",""]
        
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
                   rows(1).size = 6
                   rows(2).size = 12
                   columns(0..4).size = 7
                 end
                 
           pdf.text "\n", size: 8   
            
           starter_box = Array.new
           starter_box << ["<b>STARTER CULTURE USED</b>",""]
           starter_box << ["Type of Starter Culture Used","Qty Used"]
          # starter_box << ["",""]
  
                  pdf.table(starter_box)  do 
                    self.width = 200
                     self.cell_style = { :inline_format => true } 
                     {:borders => [:top, :left, :bottom, :right],
                     :border_width => 1,
                     :border_color => "B2BEB5",}
                     columns(0).width = 120
                     columns(1).width = 80
                     row(0).background_color = "D3D3D3"
                     rows(0).align = :center
                     rows(1).align = :center
                     rows(0).size = 7
                     rows(1).size = 6
                     rows(1).height = 40
                   end      
             
             pdf.text "\n", size: 8         
             weather_box = Array.new
             weather_box << ["<b>WEATHER TODAY</b>"]
             weather_box << [""]

                    pdf.table(weather_box)  do 
                      self.width = 200
                       self.cell_style = { :inline_format => true } 
                       {:borders => [:top, :left, :bottom, :right],
                       :border_width => 1,
                       :border_color => "B2BEB5",}
                       columns(0).width = 200
                       row(0).background_color = "D3D3D3"
                       rows(0).align = :center
                       rows(0).size = 7
                       rows(1).height = 36
                     end  
                     
               pdf.text "\n", size: 8         
               ib_change_box = Array.new
               ib_change_box << ["<b>INGREDIENT BATCH CHANGE</b>"]
               ib_change_box << [""]

                      pdf.table(ib_change_box)  do 
                        self.width = 200
                         self.cell_style = { :inline_format => true} 
                         {:borders => [:top, :left, :bottom, :right],
                         :border_width => 1,
                         :border_color => "B2BEB5",}
                         columns(0).width = 200
                         row(0).background_color = "D3D3D3"
                         rows(0).align = :center
                         rows(0).size = 7
                         rows(1).height = 36
                       end  
                       
                 pdf.text "\n", size: 8         
                 thermo_box = Array.new
                 thermo_box << ["<b>THERMOMETER CHANGE</b>", "<b>SCALE CHANGE</b>"]
                 thermo_box << ["", ""]

                        pdf.table(thermo_box)  do 
                          self.width = 200
                           self.cell_style = { :inline_format => true } 
                           {:borders => [:top, :left, :bottom, :right],
                           :border_width => 1,
                           :border_color => "B2BEB5",}
                           columns(0).width = 100
                           row(0).background_color = "D3D3D3"
                           rows(0).align = :center
                           rows(0).size = 7
                           rows(1).height = 30
                          end   
                          
                pdf.text "\n", size: 8         
                notes_box = Array.new
                notes_box << ["<b>POST MAKE NOTES</b>"]
                notes_box << [""]

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
                          rows(1).height = 80
                         end   
                         
                 pdf.text "\n", size: 8         
                 sign_box = Array.new
                 sign_box << ["<b>CHEESE MADE BY:</b>", "", "<b>MILLING HELP</b>"]
                
                        pdf.table(sign_box)  do 
                          self.width = 200
                           self.cell_style = { :inline_format => true, size: 10, :height => 70 } 
                           {:borders => [:top, :left, :bottom, :right],
                           :border_width => 1,
                           :border_color => "B2BEB5",}
                           columns(0).width = 40
                           columns(1).width = 100
                           columns(2).width = 60
                           columns(0).background_color = "D3D3D3"
                           rows(0).align = :center
                           columns(0..2).size = 7
                          end  
        
        
       end
       
       pdf.grid(0, 2).bounding_box do
        
         pdf.text "\n", size: 14        
         weight_box = Array.new
         weight_box << ["<b>WEIGHT</b>", "<b>YIELD (%)</b>"]
         weight_box << ["", ""]

                pdf.table(weight_box)  do 
                  self.width = 200
                   self.cell_style = { :inline_format => true} 
                   {:borders => [:top, :left, :bottom, :right],
                   :border_width => 1,
                   :border_color => "B2BEB5",}
                   columns(0).width = 100
                   columns(1).width = 100
                   rows(0).background_color = "D3D3D3"
                   rows(0).align = :center
                   rows(0).size = 7
                   rows(1).height = 26
                    end    
                    
          pdf.text "\n", size: 8         
          number_header_box = Array.new
          number_header_box << ["<b>NUMBER / SIZE & WEIGHT OF CHEESES MADE</b>"]
          
                 pdf.table(number_header_box)  do 
                   self.width = 200
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
                    self.width = 200
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
              
              pdf.text "\n", size: 8        
              salt_header_box = Array.new
              salt_header_box << ["<b>SALT ADDITION </b>- 2% EXPECTED CURD WEIGHT"]
          
                     pdf.table(salt_header_box)  do 
                       self.width = 200
                        self.cell_style = { :inline_format => true, :size => 10, :height => 20 } 
                        {:borders => [:top, :left, :bottom, :right],
                        :border_width => 1,
                        :border_color => "B2BEB5",}
                        rows(0).background_color = "D3D3D3"
                        rows(0).align = :center
                        rows(0).size = 7
                         end    
                     
               salt_box = Array.new
               salt_box << ["LITRES OF MILK (00's)", "EXPECTED YIELD (%)", "SALT WEIGHT (KG)\n NET     GROSS"]
               salt_box << ["  ", "  ", "  "]
             
                      pdf.table(salt_box)  do 
                        self.width = 200
                         self.cell_style = { :inline_format => true, :size => 10, :height => 22 } 
                         {:borders => [:top, :left, :bottom, :right],
                         :border_width => 1,
                         :border_color => "B2BEB5",}
                         rows(0).background_color = "D3D3D3"
                         rows(0).align = :center
                         rows(0).size = 7
                         rows(1).size = 5
                         rows(2).size = 20 
                     end     
                  
                  pdf.text "\n", size: 8         
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
                          glass_details_line <<[" YES ", "RECORD ACTIONS TAKEN BELOW", " NO "]
                            
                               pdf.table(glass_details_line)  do 
                                   self.width = 252
                                     self.cell_style = { :inline_format => true, :size => 7, :height => 24 } 
                                    {:borders => [:top, :left, :bottom, :right],
                                    :border_width => 1,
                                    :border_color => "B2BEB5",}
                                    rows(0).size = 7
                                    rows(0).align = :center
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
                                contamination_details_box <<[" YES ", "IF YES, FOLLOW W1 02,PUT HOLD, COMPLETE FB INVESTIGATION SUMMARY FORM AND EMAIL TIM", " NO "]
                            
                                     pdf.table(contamination_details_box)  do 
                                         self.width = 252
                                           self.cell_style = { :inline_format => true, :size => 7, :height => 30 } 
                                          {:borders => [:top, :left, :bottom, :right],
                                          :border_width => 1,
                                          :border_color => "B2BEB5",}
                                          rows(0).size = 7
                                          rows(0).align = :center
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
                                         metal_details_line <<[" YES ", "RECORD ACTIONS TAKEN BELOW", " NO "]
                            
                                              pdf.table(metal_details_line)  do 
                                                  self.width = 252
                                                    self.cell_style = { :inline_format => true, :size => 7, :height => 24 } 
                                                   {:borders => [:top, :left, :bottom, :right],
                                                   :border_width => 1,
                                                   :border_color => "B2BEB5",}
                                                   rows(0).size = 7
                                                   rows(0).align = :center
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
                                               contamination_details_box <<[" YES ", "IF YES, FOLLOW W1 02,PUT HOLD, COMPLETE FB INVESTIGATION SUMMARY FORM AND EMAIL TIM", " NO "]
                            
                                                    pdf.table(contamination_details_box)  do 
                                                        self.width = 252
                                                          self.cell_style = { :inline_format => true, :size => 7, :height => 30 } 
                                                         {:borders => [:top, :left, :bottom, :right],
                                                         :border_width => 1,
                                                         :border_color => "B2BEB5",}
                                                         rows(0).size = 7
                                                         rows(0).align = :center
                                   
                                                    end
                                                    
                                                    pdf.text "\n", size: 8         
                                                    comments_box = Array.new
                                                    comments_box << ["<b>COMMENTS AND CORRECTIVE ACTIONS</b>"]
                                                    comments_box << [""]

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
                                                              rows(1).height = 30
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
      params.require(:makesheet).permit(:status, :make_date, :milk_used, :total_weight, :number_of_cheeses, :grade, :weight_type)
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
end
