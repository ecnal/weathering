require 'rails_helper'

RSpec.describe WeatherApiAdapter do
  let(:adapter) { WeatherApiAdapter.new }
  let(:bad_request) { '1' }
  let(:zipcode_only) { '02066' }
  let(:full_address) { '55 Main St, Quincy, MA 02169' }
  let(:no_zipcode) { 'London' }

  describe '#get_forecast' do
    it 'returns error_message for a bad request' do
      VCR.use_cassette('weather_api_bad_request') do
        forecast = adapter.get_forecast(bad_request)
        expect(forecast).to be_a(Hash)
        expect(forecast[:error_message]).to eq('No matching address found.')
      end
    end

    it 'returns a response for a zipcode only request' do
      VCR.use_cassette('weather_api_zipcode_only') do
        forecast = adapter.get_forecast(zipcode_only)
        expect(forecast).to be_a(Hash)
        expect(forecast[:current_temp]).to eq(68.0)
      end
    end

    it 'returns a response for a full address request' do
      VCR.use_cassette('weather_api_full_address') do
        forecast = adapter.get_forecast(full_address)
        expect(forecast).to be_a(Hash)
        expect(forecast[:current_temp]).to eq(66.0)
      end
    end

    it 'returns a response for a request with no zipcode' do
      VCR.use_cassette('weather_api_no_zipcode') do
        forecast = adapter.get_forecast(no_zipcode)
        expect(forecast).to be_a(Hash)
        expect(forecast[:current_temp]).to eq(57.2)
      end
    end
  end
end
