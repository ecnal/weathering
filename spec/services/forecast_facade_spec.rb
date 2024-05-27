require 'rails_helper'

RSpec.describe ForecastFacade do
  let(:empty_address) { '' }
  let(:zipcode_only) { '02066' }
  let(:full_address) { '55 Main St, Quincy, MA 02169' }
  let(:no_zipcode) { 'London' }

  describe '#forecast' do
    context 'when the forecast is cached' do
      let(:cached_forecast) { { current_temperature: '75' } }

      before do
        allow(CacheService).to receive(:get).and_return(cached_forecast)
      end

      it 'returns the cached forecast' do
        facade = ForecastFacade.new(address: full_address)
        expect(facade.forecast).to eq([true, cached_forecast])
      end
    end

    context 'when the forecast is not cached' do
      let(:fetched_forecast) { { current_temperature: '80' } }

      before do
        allow(CacheService).to receive(:get).and_return(nil)
        allow(CacheService).to receive(:set)
        allow_any_instance_of(WeatherService).to receive(:get_forecast).and_return(fetched_forecast)
      end

      it 'fetches the forecast from the weather service and caches it' do
        facade = ForecastFacade.new(address: full_address)
        expect(facade.forecast).to eq([false, fetched_forecast])
        expect(CacheService).to have_received(:set)
      end
    end

    context 'when the address is empty' do
      it 'returns an error message' do
        facade = ForecastFacade.new(address: empty_address)
        expect(facade.forecast[1][:error_message]).to eq('Please type in an address.')
      end
    end
  end

  describe '#zipcode' do
    it 'returns a zipcode for a full address request' do
      facade = ForecastFacade.new(address: full_address)
      expect(facade.send(:zipcode)).to eq('02169')
    end

    it 'returns a zipcode for a zipcode only request' do
      facade = ForecastFacade.new(address: zipcode_only)
      expect(facade.send(:zipcode)).to eq('02066')
    end

    it 'returns a nil for a request without a zipcode' do
      facade = ForecastFacade.new(address: no_zipcode)
      expect(facade.send(:zipcode)).to be_nil
    end
  end
end
