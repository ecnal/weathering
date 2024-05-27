class WeatherApiAdapter < WeatherAdapter
  def get_forecast(address)
    # Set timeouts for badly configured APIs
    faraday_options = {
      request: {
        open_timeout: 1,
        read_timeout: 1,
        write_timeout: 1
      }
    }

    # using :net_http_persistent reuses a single longer-lived socket reducing load on API
    conn = Faraday.new(**faraday_options) do |config|
      config.response :json
      config.response :raise_error
      config.response :logger, Rails.logger, headers: false, bodies: true, log_level: :debug
      config.adapter :net_http_persistent
    end

    response = conn.get("http://api.weatherapi.com/v1/current.json?key=#{ENV.fetch('WEATHER_API_TOKEN')}&q=#{address}&aqi=no")
    external_forecast = response.body

    # Relevant Forecast Data in Internal format
    {
      location: external_forecast['location']['name'],
      current_temp: external_forecast['current']['temp_f']
    }
  rescue Faraday::BadRequestError
    { error_message: 'No matching address found.' }
  end
end
