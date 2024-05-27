# Weathering Weather Forecast App

This is a Ruby on Rails application that allows users to retrieve weather forecasts for a given address.
The app caches the forecast data for valid US zipcodes to improve performance.
If the address does not include a valid US zipcode then the request for a forecast will still be processed, but it will not be cached.

## Features

- Retrieve current temperature and other forecast details for a provided address
- Support for WeatherAPI.com and Tomorrow.io API API (more APIs can be added)
- Caching of forecast data for 30 minutes per address for addresses with a valid US zipcode

## Architecture

The app follows a modular design pattern and separates concerns using several key components:

1. **Controllers**: Handle the HTTP requests and responses, and coordinate the application's flow.
2. **Facade**: Encapsulate the business logic related to fetching and caching forecast data.
3. **Services**: Provide an abstraction layer for interacting with external weather APIs.
4. **Adapters**: Implement the logic for communicating with specific weather APIs, translating requests and responses as needed.

### Key Components

#### `HomeController`
- Handles the user's request for a forecast
- Creates an instance of `ForecastFacade` and delegates forecast retrieval and caching to it
- Renders the appropriate view based on the form's validity and forecast data

#### `ForecastFacade`
- Encapsulates the business logic for fetching and caching forecast data
- Retrieves cached forecast data if available, or fetches and caches new data
- Interacts with the `WeatherService` and `CacheService` to perform its tasks

#### `WeatherService`
- Provides a unified interface for interacting with weather API adapters
- Delegates the actual forecast retrieval to the appropriate adapter based on the configured strategy

#### `WeatherAdapter` (Abstract Base Class)
- Defines the interface for concrete API adapter implementations
- Requires concrete adapters to implement the `get_forecast` method

#### `WeatherAPIAdapter` and `TomorrowAdapter`
- Concrete implementations of the `WeatherAdapter` interface
- Responsible for communicating with their respective weather APIs, translating requests and responses as needed

#### `CacheService`
- Provides methods for getting and setting cached forecast data

### Installation and Setup

1. Clone the repository:
git clone https://github.com/ecnal/weathering.git

2. Install dependencies:
bundle install

3. Create the .env.development.local file and add the WEATHER_API_TOKEN and/or TOMORROW_API_TOKEN variables

4. Enable caching:
rails dev:cache

5. Start the server:
bin/dev

6. Open your web browser and visit `http://localhost:3000`

### Testing

The app includes RSpec tests for the key components, including the `ForecastFacade`, `HomeController`, and API adapters. To run the tests, execute the following command:

bundle exec rspec