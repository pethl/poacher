class MakesheetsController < ApplicationController
  require_relative Rails.root.join('services/weather_service')
  before_action :authenticate_user!
  before_action :set_makesheet, only: %i[ show edit update destroy batch_turns]
  before_action :set_cheese_makers, only: %i[ new create edit update destroy ]
  def makesheet_search
    if params[:search_by_batch] && params[:search_by_batch] != ""
      @makesheets = Makesheet.where(batch: params[:search_by_batch])
    end 
  end
  def overview
  end  

  def yield_dashboard
    @make_types = Makesheet.distinct.pluck(:make_type)
  
    @projected_yields = @make_types.each_with_object({}) do |make_type, hash|
      avg_yield = Makesheet.average_yield_for(make_type)
      hash[make_type] = avg_yield.round(2) if avg_yield
    end
  
    @yield_data = @make_types.each_with_object({}) do |make_type, hash|
      sheets = Makesheet.where(make_type: make_type)
                        .where.not(milk_used: [nil, 0])
                        .order(make_date: :desc)
                        .limit(10)
  
      data = sheets.reverse.map do |sheet|
        {
          x: sheet.make_date.strftime("%Y-%m-%d"),
          y: (sheet.total_weight.to_f / sheet.milk_used.to_f * 100).round(2)
        }
      end
  
      hash[make_type] = data
    end
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

      @large_poacher_count = @makesheets
      .where(weight_type: "Standard (20 kgs)")
      .where(make_type: ["Standard", "P50"])
      .pluck(:number_of_cheeses)
      .compact
      .sum
    
    @large_poacher_weight = @makesheets
      .where(weight_type: "Standard (20 kgs)")
      .where(make_type: ["Standard", "P50"])
      .pluck(:total_weight)
      .compact
      .sum
    
      @red_poacher_count =  @makesheets.where(weight_type: "Half Truckle (10kgs)").where(make_type: "Red").pluck(:number_of_cheeses).compact.sum
      @red_poacher_weight =  @makesheets.where(weight_type: "Half Truckle (10kgs)").where(make_type: "Red").pluck(:total_weight).compact.sum

      @medium_cheese_count =  @makesheets.where(weight_type: "Midi (8 kgs)").pluck(:number_of_cheeses).compact.sum
      @medium_cheese_weight = @makesheets.where(weight_type: "Midi (8 kgs)").pluck(:total_weight).compact.sum

      @small_cheese_count =  @makesheets.where(weight_type: "2.5kg").pluck(:number_of_cheeses).compact.sum
      @small_cheese_weight = @makesheets.where(weight_type: "2.5kg").pluck(:total_weight).compact.sum

      @data = @makesheets.ordered.pluck(:make_date, :milk_used).map do |make_date, milk_used|
        [make_date&.strftime("%-d"), milk_used] if make_date.present?
      end.compact.to_h
     
  end
  
  
  # GET /makesheets or /makesheets.json
  def index
    @makesheets = Makesheet.all

    # Apply search filter if a date is provided
    @makesheets = @makesheets.where(make_date: params[:search]) if params[:search].present?
  
    # Apply sorting if column and direction are provided
    if params[:column].present? && params[:direction].present?
      @makesheets = @makesheets.order("#{params[:column]} #{params[:direction]}")
    else
      @makesheets = @makesheets.ordered_reverse
    end
  end

  # GET /makesheets/1 or /makesheets/1.json
  def show
    @samples = @makesheet.samples

    prepare_chart_data # Call the reusable method
  end

  # GET /makesheets/new
  def new
    @makesheet = Makesheet.new(
    make_type: params[:make_type], 
    weight_type: params[:weight_type],
    glass_breakage: false,
    metal_breakage: false,
    make_date: Date.today
  )
  # Set expected_yield from predicted_yield if make_type is present
  if @makesheet.make_type.present?
    @makesheet.expected_yield = @makesheet.predicted_yield.to_f.round(2)
  end
    #no need to define location as its hard coded in service
    service = WeatherService.new
    @weather = service.fetch_daily_weather
 
    if @weather
      @makesheet.weather_today = @weather[:conditions]
      @makesheet.weather_temp = @weather[:temperature]
      @makesheet.weather_humidity = @weather[:humidity]
    else
      flash[:alert] = "Weather data unavailable"
    end
     
  end

  # GET /makesheets/1/edit
  def edit
    prepare_chart_data # Call the reusable method
  end

  # POST /makesheets or /makesheets.json
  def create
    @makesheet = Makesheet.new(makesheet_params)
    @makesheet.batch = (@makesheet.make_date + 6.years).strftime("%d-%m-%y")

    respond_to do |format|
      if @makesheet.save
        format.html { redirect_to makesheets_path, notice: "Makesheet was successfully created." }
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
        format.html { redirect_to makesheets_path, notice: "Makesheet was successfully updated." }
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
    makesheet = Makesheet.find(params[:id]) # Fetch the makesheet
    pdf_data = MakesheetPdfGenerator.new(makesheet).generate # Get the PDF data
  
    send_data pdf_data, 
              filename: "makesheet_#{makesheet.id}.pdf",
              type: "application/pdf",
              disposition: "inline" # or "attachment" to force download
  end 

   #used in JS by traceability records form
  def summary
    makesheet = Makesheet.find(params[:id])
    render json: {
      batch: makesheet.batch,
      number_of_cheeses: makesheet.number_of_cheeses,
      total_weight: makesheet.total_weight
    }
  end
  
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_makesheet
      @makesheet = Makesheet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def makesheet_params
      params.require(:makesheet).permit(:status, :make_date, :make_type, 
      :milk_used, :total_weight, :number_of_cheeses, :weight_type, :grade, :expected_yield,
      :boiler_on_time, :steam_hot_water_on_time, :cold_milk_in_time, :cold_milk_in_state, :warm_milk_finish_time, :warm_milk_finish_titration, 
      :starter_in_time, :starter_in_temp, :heat_off_1_time, :heat_off_1_temp, :milk_titration_time, :milk_titration_temp, :rennet_time, :rennet_temp, 
      :cut_start_time, :cut_end_time, :heat_on_time, :heat_off_2_time, :heat_off_2_temp, :pitch_time, :whey_time, :whey_titration, 
      :first_cut_time, :first_cut_titration, :second_cut_time, :second_cut_titration, :third_cut_time, :third_cut_titration, :fourth_cut_time, :fourth_cut_titration, :fifth_cut_time, :fifth_cut_titration, :sixth_cut_time, :sixth_cut_titration, :identify_mill_used, 
      :warm_am, :twelve_hr_pm, :unusual_smell_appearance, :number_of_bottles_from_fm, :use_by_date_milk_from_fm, 
      :type_of_starter_culture_used, :qty_of_starter_used, :pre_start_inspection_of_high_risk_items, :pre_start_inspection_by_staff_id, 
      :ingredient_batch_change, :thermometer_change, :scale_change, :farm_change, :batch_dipped, :post_make_notes, :milling_help, :cheese_made_by_staff_id, :assistant_staff_id,:salt_weight_net, :salt_weight_gross, 
      :weather_today, :weather_temp, :weather_humidity, :glass_breakage, :glass_contamination, :glass_comments, :metal_breakage, :metal_contamination, :metal_comments, :slow_cheese, :step_1_curd_sample, :step_2_record_as_slow, :step_3_record_reason, :step_4_notify_tim, :step_5_apply_label, :step_6_record_red_book)
    end

    def set_cheese_makers
      @cheese_makers = Staff.where(dept: "Cheesemaking Team").where(employment_status: "Active").ordered
    end

     # Private method to prepare chart data
     def prepare_chart_data
      
      # Define the titration values and the corresponding cuts, only including if both are present
      titration_data = [
        { cut: @makesheet.first_cut_time, titration: @makesheet.first_cut_titration },
        { cut: @makesheet.second_cut_time, titration: @makesheet.second_cut_titration },
        { cut: @makesheet.third_cut_time, titration: @makesheet.third_cut_titration },
        { cut: @makesheet.fourth_cut_time, titration: @makesheet.fourth_cut_titration },
        { cut: @makesheet.fifth_cut_time, titration: @makesheet.fifth_cut_titration },
        { cut: @makesheet.sixth_cut_time, titration: @makesheet.sixth_cut_titration }
      ]

      # Select only the entries where both cut time and titration are present
      titration_data = titration_data.select do |data|
        data[:cut].present? && data[:titration].present?
      end

      # Format the cut time and prepare the data for the chart
      @chart_data = titration_data.map do |data|
        # Ensure the cut time is a valid Time object before calling strftime
        cut_time = Time.parse(data[:cut].to_s) rescue nil
        if cut_time
          [cut_time.strftime("%H:%M"), data[:titration]]
        else
          nil
        end
      end.compact
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
        @location = "LN130HE"
        @api_key = ENV['openweather_api_key'] # Fix ENV.fetch issue
       # raise "Missing OpenWeather API Key" unless api_key
      end
    
      def fetch_weather
        # @location = "LN130HE"
        # @api_key = ENV.fetch['openweather_api_key'] # Store your API key in the environment
        options = { query: { q: @location, appid: @api_key, units: 'metric' } }
        begin
        response = self.class.get('/weather', options)
        parse_response(response)
        rescue StandardError => e
          Rails.logger.error "Weather API request failed: #{e.message}"
          nil
        end
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
