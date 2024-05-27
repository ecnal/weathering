class WeatherAdapter
  def get_forecast(address)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end
