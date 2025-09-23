class MakesheetsController < ApplicationController
  require_relative Rails.root.join('services/weather_service')
  before_action :authenticate_user!
  before_action :set_makesheet, only: %i[ show edit update destroy batch_turns]
  before_action :set_cheese_makers, only: %i[ new create edit update destroy ]
  before_action :set_bucket_tare, only: [:new, :create, :edit, :update]
  before_action :set_starter_defaults,  only: [:new, :create, :edit, :update]

  

  def makesheet_search
    if params[:search_by_batch] && params[:search_by_batch] != ""
      @makesheets = Makesheet.where(batch: params[:search_by_batch])
    end 
  end




  def recent
    limit = params.fetch(:limit, 4).to_i.clamp(1, 20)
  
    @recent_makesheets = Makesheet
      .where.not(make_date: Date.current.all_day) # exclude anything dated today
      .order(make_date: :desc)
      .limit(limit)
  
    render partial: "makesheets/recent_makesheets",
           locals: { makesheets: @recent_makesheets }
  end

  def overview
  end  



  def yield_dashboard
    @make_types = Makesheet.distinct.pluck(:make_type)
  
    @projected_yields = @make_types.each_with_object({}) do |make_type, hash|
      avg_yield = Makesheet.average_recent_yield
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
    month = params[:month].to_i
    year = params[:year].to_i
  
    if month.positive? && year.positive?
      @makesheets = Makesheet.filter_by_month_and_year(month, year).ordered
    else
      @makesheets = Makesheet.where(
        make_date: Date.today.beginning_of_month..Date.today.end_of_month
      ).ordered
    end
  
    # Totals
    @total_monthly_milk_litres = @makesheets.pluck(:milk_used).compact.sum
  
    @large_poacher_scope = @makesheets.where(weight_type: "Standard (20 kgs)", make_type: ["Standard", "P50"])
    @large_poacher_count = @large_poacher_scope.pluck(:number_of_cheeses).compact.sum
    @large_poacher_weight = @large_poacher_scope.pluck(:total_weight).compact.sum
  
    @red_poacher_scope = @makesheets.where(weight_type: "Half Truckle (10kgs)", make_type: "Red")
    @red_poacher_count = @red_poacher_scope.pluck(:number_of_cheeses).compact.sum
    @red_poacher_weight = @red_poacher_scope.pluck(:total_weight).compact.sum
  
    @medium_scope = @makesheets.where(weight_type: "Midi (8 kgs)")
    @medium_cheese_count = @medium_scope.pluck(:number_of_cheeses).compact.sum
    @medium_cheese_weight = @medium_scope.pluck(:total_weight).compact.sum
  
    @small_scope = @makesheets.where(weight_type: "2.5kg")
    @small_cheese_count = @small_scope.pluck(:number_of_cheeses).compact.sum
    @small_cheese_weight = @small_scope.pluck(:total_weight).compact.sum
  
    # Chart data (already ordered above)
    @data = @makesheets.pluck(:make_date, :milk_used).map do |make_date, milk_used|
      [make_date.strftime("%-d"), milk_used] if make_date.present?
    end.compact.to_h
  
    # Averages (prevent divide-by-zero)
    milk_record_count = @makesheets.where.not(milk_used: nil).count.nonzero? || 1
    @average_milk_used = @total_monthly_milk_litres / milk_record_count.to_f
  
    large_count = @large_poacher_scope.count.nonzero? || 1
    @average_large_poacher_count = @large_poacher_count / large_count.to_f
    @average_large_poacher_weight = @large_poacher_weight / large_count.to_f
  
    red_count = @red_poacher_scope.count.nonzero? || 1
    @average_red_poacher_count = @red_poacher_count / red_count.to_f
    @average_red_poacher_weight = @red_poacher_weight / red_count.to_f
  
    medium_count = @medium_scope.count.nonzero? || 1
    @average_medium_cheese_count = @medium_cheese_count / medium_count.to_f
    @average_medium_cheese_weight = @medium_cheese_weight / medium_count.to_f
  
    small_count = @small_scope.count.nonzero? || 1
    @average_small_cheese_count = @small_cheese_count / small_count.to_f
    @average_small_cheese_weight = @small_cheese_weight / small_count.to_f
  end




   # GET /makesheets/rennet_for_milk?milk_volume=1234
   def rennet_for_milk_lookup
    milk = params[:milk_volume]
    amount = rennet_for_milk(milk) # <- your helper method in ApplicationHelper
    render json: { rennet: amount.present? ? amount.to_f : nil }
  end
  
  
  
  # GET /makesheets or /makesheets.json
  def index
    # Allow :search to alias to makesheet_id (from shared picker)
    params[:makesheet_id] ||= params[:search]
  
    # Start with all makesheets
    @makesheets = Makesheet.all
  
    # Filter by selected makesheet
    if params[:makesheet_id].present?
      @makesheets = @makesheets.where(id: params[:makesheet_id])
    end
  
    # Filter by month (e.g. "Jan-24")
    if params[:month].present?
      begin
        month_date = Date.strptime(params[:month], "%b-%y")
        @makesheets = @makesheets.where(make_date: month_date.all_month)
      rescue ArgumentError
        # Invalid format — do nothing
      end
    end
  
    # Eager load associations used in views or methods (especially flags!)
    @makesheets = @makesheets.includes(:location, :samples)
  
    # Sorting logic
    if params[:column] == "location.name"
      @makesheets = @makesheets.joins(:location).order("locations.name #{sort_direction}")
    elsif params[:column].present? && Makesheet.column_names.include?(params[:column])
      @makesheets = @makesheets.order("#{params[:column]} #{sort_direction}")
    else
      @makesheets = @makesheets.ordered_reverse
    end
  
    # Available month options for the dropdown
    @available_months = Makesheet
      .where.not(make_date: nil)
      .pluck(:make_date)
      .map { |d| d.strftime("%b-%y") }
      .uniq
      .sort_by { |m| Date.strptime(m, "%b-%y") }
  end
  
  
  
  # GET /makesheets/1 or /makesheets/1.json
  def show
    @samples = @makesheet.samples

    @makesheet = Makesheet.find(params[:id])
    @qr_data = "28-05-2025 #{@makesheet.id}" # adjust as needed
  end



  def qr_code
    makesheet = Makesheet.find(params[:id])
    data = "28-05-2025 #{makesheet.id}"

    png_data = CheeseQrCodeGenerator.new(data).render_png
    send_data png_data, type: 'image/png', disposition: 'inline'
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



  def simple_new
    @makesheet = Makesheet.new(status: "Store", make_type: "Standard", weight_type: "Standard (20 kgs)")
    render :simple_form
  end



  # GET /makesheets/1/edit
  def edit
    prepare_chart_data(@makesheet)
   
    # for the ingredient-batch-change panel
    @items         = dairy_ingredients
    @selected_item = params[:ingredient].presence   # use :ingredient to avoid clashing with makesheet params
    @recent_deliveries = @selected_item.present? ? DeliveryInspection.last_three_for_item(@selected_item) : []
  end



  # POST /makesheets or /makesheets.json
  def create
    @makesheet = Makesheet.new(makesheet_params)
    @makesheet.batch = (@makesheet.make_date + 6.years).strftime("%d-%m-%y")
  
    if @makesheet.save
      # Decide where to go based on which button was pressed
      dest =
        if params[:save_and_continue].present?
          edit_makesheet_path(@makesheet)       # stay on edit
        elsif params[:save_and_finish].present?
          makesheets_path           # go to index
        else
          makesheets_path                       # default: index (your current behavior)
        end
  
      respond_to do |format|
        format.turbo_stream { redirect_to dest, notice: "Makesheet created." }
        format.html        { redirect_to dest, notice: "Makesheet created." }
        format.json        { render :show, status: :created, location: @makesheet }
      end
    else
      respond_to do |format|
        if request.referer&.include?("/simple_new")
          format.html        { render :simple_form, status: :unprocessable_entity }
          format.turbo_stream { render :simple_form, status: :unprocessable_entity }
        else
          format.html        { render :new, status: :unprocessable_entity }
          format.turbo_stream { render :new, status: :unprocessable_entity }
        end
        format.json { render json: @makesheet.errors, status: :unprocessable_entity }
      end
    end
  end

  
  
  def update
    if @makesheet.update(makesheet_params)
      # Decide where to go based on which button was pressed
      dest =
        if params[:save_and_continue].present?
          edit_makesheet_path(@makesheet)       # stay on edit
        elsif params[:save_and_finish].present?
          makesheets_path           # go to index
        else
          makesheets_path                       # default: index (your current behavior)
        end
  
      respond_to do |format|
        format.turbo_stream { redirect_to dest, notice: "Makesheet was updated." }
        format.html        { redirect_to dest, notice: "Makesheet was updated." }
        format.json        { render :show, status: :ok, location: @makesheet }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :edit, status: :unprocessable_entity }
        format.html        { render :edit, status: :unprocessable_entity }
        format.json        { render json: @makesheet.errors, status: :unprocessable_entity }
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
    makesheet = Makesheet.find(params[:id])
    chart_data = prepare_chart_data(makesheet) # Call and capture chart data
  
    pdf_data = MakesheetPdfGenerator.new(makesheet, chart_data).generate
  
    send_data pdf_data, 
              filename: "makesheet_#{makesheet.id}.pdf",
              type: "application/pdf",
              disposition: "inline"
  end

   #used in JS by traceability records form - very important never delete
   def summary
    makesheet     = Makesheet.find(params[:id])
    traceability  = makesheet.traceability_records.first
  
    render json: {
      batch: makesheet.batch,
      number_of_cheeses: makesheet.number_of_cheeses,
      total_weight: makesheet.total_weight,
      grade: makesheet.grade,
      total_weight_of_batch: traceability&.total_weight_of_batch,
      total_waste: traceability&.total_waste,
  
      # 👇 Added for cheese wash summary
      make_date: makesheet.make_date&.strftime("%Y-%m-%d"),
      post_make_notes: makesheet.post_make_notes,
      flags: makesheet.flags
    }
  end
  
  def on_hold
    @status_filter = params[:status] == "finished" ? "Finished" : nil
  
    @makesheets = Makesheet
      .where("glass_breakage = ? OR metal_contamination = ? OR slow_cheese = ?", true, true, true)
      .order(make_date: :desc)
  
    @makesheets = @makesheets.where.not(status: "Finished") unless @status_filter
    @makesheets = @makesheets.where(status: "Finished") if @status_filter
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_makesheet
      @makesheet = Makesheet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    # location_id removed 
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
      :weather_today, :weather_temp, :weather_humidity, :glass_breakage, :glass_contamination, :glass_comments, :metal_breakage, :metal_contamination, :metal_comments, 
      :slow_cheese, :step_1_curd_sample, :step_2_record_as_slow, :step_3_record_reason, :step_4_notify_tim, :step_5_apply_label, :step_6_record_red_book, 
      :ta_combined_milk,
      :whey_ta,
      :curd_temp,
      :room_temp,
      :visual_moisture_post_milling,
      :moisture_percentage_post_milling,
      :record_of_works_completed, 
      :annatto_in_time, :annatto_in_temp, :md_88_in_time, :md_88_in_temp, :md_88_qty_used,
      :pre_start_inspection_by_2_staff_id,
      :seventh_cut_time,
      :seventh_cut_titration,
      :freezer_temp,
      :rennet_used,
      :rennet_weight_used,
      :chiller_temp,
      :churns_out,
      :samples_required_summary
      )
    end

    def set_cheese_makers
      @cheese_makers = Staff.where(dept: "Cheesemaking Team").where(employment_status: "Active").ordered
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

     # Private method to prepare chart data
     def prepare_chart_data(makesheet)
        titration_data = [
          { cut: makesheet.first_cut_time, titration: makesheet.first_cut_titration },
          { cut: makesheet.second_cut_time, titration: makesheet.second_cut_titration },
          { cut: makesheet.third_cut_time, titration: makesheet.third_cut_titration },
          { cut: makesheet.fourth_cut_time, titration: makesheet.fourth_cut_titration },
          { cut: makesheet.fifth_cut_time, titration: makesheet.fifth_cut_titration },
          { cut: makesheet.sixth_cut_time, titration: makesheet.sixth_cut_titration }
        ]

        titration_data.select { |d| d[:cut].present? && d[:titration].present? }.map do |data|
          cut_time = Time.parse(data[:cut].to_s) rescue nil
          cut_time ? [cut_time.strftime("%H:%M"), data[:titration]] : nil
        end.compact

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

    def set_bucket_tare
      @bucket_weight_kg = bucket_tare_kg(for_model: "MakeSheet", default: 1.6)
    end

    def set_bucket_tare
      @bucket_weight_kg = bucket_tare_kg(for_model: "MakeSheet", default: 1.6)
    end
  
    def set_starter_defaults
      # use the current form's date if present, else today
      as_of = @makesheet&.make_date || Date.current
      @starter_types   = starter_types(for_model: "MakeSheet")
      @starter_default = next_starter_type(for_model: "MakeSheet", as_of: as_of)
    end
end
