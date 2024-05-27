require 'rails_helper'

RSpec.describe 'Homes', type: :request do
  describe 'GET /' do
    it 'returns http success' do
      get '/'
      expect(response).to have_http_status(:success)
    end

    it 'returns http success' do
      VCR.use_cassette('weather_api_zipcode_only') do
        get '/?address=02066'
        expect(response).to have_http_status(:success)
      end
    end

    it 'returns http success' do
      VCR.use_cassette('weather_api_full_address') do
        get '/?address=55+Main+St%2C+Quincy%2C+MA+02169'
        expect(response).to have_http_status(:success)
      end
    end

    it 'returns http success' do
      VCR.use_cassette('weather_api_bad_request') do
        get '/?address=1'
        expect(response).to have_http_status(:success)
      end
    end

    it 'returns http success' do
      VCR.use_cassette('weather_api_no_zipcode') do
        get '/?address=London'
        expect(response).to have_http_status(:success)
      end
    end
  end
end
