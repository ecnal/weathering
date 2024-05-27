class ForecastFacade
  def initialize(address:)
    @address = address
  end

  # Returns a memoized [Boolean, Hash]
  # The Boolean value is the source of the forecast, from the Cache or not
  # The Hash value is the forecast data
  def forecast
    @forecast ||= [cached_forecast.present?, cached_forecast || fetch_forecast]
  end

  private

  attr_reader :address

  # Find and return a memoized zipcode withing address else return nil
  def zipcode
    return @zipcode if defined? @zipcode

    @zipcode = begin
      zipcode = address if valid_zipcode?(address)
      parsed = address.split(' ').last.split('-').first
      zipcode ||= parsed if valid_zipcode?(parsed)
    end
  end

  # Find and return a memoized cached forecast for a valid zipcode else return nil
  def cached_forecast
    return @cached_forecast if defined? @cached_forecast

    @cached_forecast = begin
      return if address.blank?
      return if zipcode.blank?

      CacheService.get(cache_key)
    end
  end

  # If the address is blank then return an error_message
  # Cache the forecast for a valid zipcode
  # Return a memoized forecast from an API for a valid address
  def fetch_forecast
    return { error_message: 'Please type in an address.' } if address.blank?

    weather_adapter = WeatherApiAdapter.new
    weather_service = WeatherService.new(weather_adapter)
    forecast = weather_service.get_forecast(address)
    CacheService.set(cache_key, forecast, 30.minutes) if zipcode.present?
    forecast
  end

  def cache_key
    @cache_key ||= "forecast_#{zipcode}"
  end

  def valid_zipcode?(zip)
    zipcode_regex = /\A\d{5}?\z/
    zip.match?(zipcode_regex)
  end
end
