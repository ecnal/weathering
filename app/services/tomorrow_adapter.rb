class TomorrowAdapter < WeatherAdapter
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
      config.request :instrumentation, name: 'forecast.faraday'
      config.response :json
      config.response :raise_error
      config.response :logger, Rails.logger, headers: false, bodies: true, log_level: :debug
      config.adapter :net_http_persistent
    end

    response = conn.get("https://api.tomorrow.io/v4/weather/realtime?location=#{address}&units=imperial&apikey=#{ENV.fetch('TOMORROW_API_TOKEN')}")
    external_forecast = response.body

    # Relevant Forecast Data in Internal format
    {
      location: address,
      current_temp: external_forecast['data']['values']['temperature']
    }
  rescue Faraday::BadRequestError
    { error_message: 'No matching address found.' }
  end
end
