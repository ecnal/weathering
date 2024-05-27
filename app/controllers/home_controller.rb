class HomeController < ApplicationController
  def index
    # Make sure there is an address parameter before fetching a forecast
    return unless params.key?(:address)

    @address = params[:address]
    @cached, @forecast = ForecastFacade.new(address: @address).forecast
  end
end
