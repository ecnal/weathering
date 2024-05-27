ActiveSupport::Notifications.subscribe('forecast.faraday') do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  url = event.payload[:url]
  http_method = event.payload[:method].to_s.upcase
  log_prefix = event.name.split('.').last.camelize
  output = format('[%s] %s %s %s (Duration: %sms)', log_prefix, url.host, http_method, url.request_uri,
                  event.duration.round(1))
  Rails.logger.info(output)
end
