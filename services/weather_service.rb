class WeatherService
  include HTTParty
 
  base_uri 'http://api.weatherapi.com/v1'

  def initialize(location = "LN130HE")
    @location = location
    @api_key = ENV['WEATHER_API_KEY']
    @logger = Rails.logger # Use Rails logger for consistency

  end

  def fetch_daily_weather
    options = { query: { key: @api_key, q: @location, aqi: 'no' } }
     # Log the request details
     @logger.info("===== WeatherAPI Request =====")
     @logger.info("WeatherAPI Request: #{options[:query].to_json}")
     @logger.info("===== End Request =====")

   

    response = self.class.get('/current.json', options)
     # Log the full response
     @logger.info("===== WeatherAPI Response =====")
     @logger.info("WeatherAPI Response: #{response.body}")
     @logger.info("===== End Response =====")
    
      
     parse_response(response)
    rescue => e
      @logger.error("WeatherAPI Error: #{e.message}")
      { error: 'An error occurred while fetching weather data.' }
    end
  end

  private

  def parse_response(response)
    if response.success?
      {
        conditions: response['current']['condition']['text'],
        temperature: response['current']['temp_c'],
        humidity: response['current']['humidity']
      }
    else
      { error: response['error']['message'] || 'Unable to fetch weather data' }
    end

end