require 'rails_helper'

RSpec.describe TomorrowAdapter do
  let(:adapter) { TomorrowAdapter.new }
  let(:bad_request) { '1' }
  let(:zipcode_only) { '02066' }
  let(:full_address) { '55 Main St, Quincy, MA 02169' }
  let(:no_zipcode) { 'London' }

  describe '#get_forecast' do
    it 'returns error_message for a bad request' do
      VCR.use_cassette('tomorrow_bad_request') do
        forecast = adapter.get_forecast(bad_request)
        expect(forecast).to be_a(Hash)
        expect(forecast[:error_message]).to eq('No matching address found.')
      end
    end

    it 'returns a response for a zipcode only request' do
      VCR.use_cassette('tomorrow_zipcode_only') do
        forecast = adapter.get_forecast(zipcode_only)
        expect(forecast).to be_a(Hash)
        expect(forecast[:current_temp]).to eq(65.08)
      end
    end

    it 'returns a response for a full address request' do
      VCR.use_cassette('tomorrow_full_address') do
        forecast = adapter.get_forecast(full_address)
        expect(forecast).to be_a(Hash)
        expect(forecast[:current_temp]).to eq(73.63)
      end
    end

    it 'returns a response for a request with no zipcode' do
      VCR.use_cassette('tomorrow_no_zipcode') do
        forecast = adapter.get_forecast(no_zipcode)
        expect(forecast).to be_a(Hash)
        expect(forecast[:current_temp]).to eq(55.18)
      end
    end

    it 'returns an error message when there is a problem with the endpoint' do
      VCR.use_cassette('tomorrow_connection_error') do
        forecast = adapter.get_forecast(no_zipcode)
        expect(forecast).to be_a(Hash)
        expect(forecast[:error_message]).to eq('Something went wrong. Please try again later.')
      end
    end

    context 'without using VCR for rescuing a StandarError' do
      before do
        allow(Faraday).to receive(:get).and_raise(Faraday::TimeoutError)
      end

      it 'returns an error_message when a TimeoutError occurs' do
        forecast = adapter.get_forecast(full_address)
        expect(forecast).to eq({ error_message: 'Something went wrong. Please try again later.' })
      end
    end
  end
end
