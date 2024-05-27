class WeatherService
  def initialize(weather_adapter)
    @weather_adapter = weather_adapter
  end

  def get_forecast(address)
    @weather_adapter.get_forecast(address)
  end
end
