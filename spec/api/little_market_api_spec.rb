


require 'rails_helper'
require 'airborne'
require 'pp'

require_relative '../../lib/little_market'
require_relative '../fixtures/creations'

Airborne.configure do |config|
  config.rack_app = LittleMarket::API
end

describe LittleMarket::API, type: :request do
  include Rack::Test::Methods

  describe LittleMarket::API do
    describe 'GET /api/creations' do

      it 'return empty array of creations' do
        LittleMarket::Connection.new 'lucien.farstein@gmail.com', 'toto555500'
        get '/api/creations'
        expect(last_response.status).to eq 200
        json_data = JSON.parse(last_response.body)
        expect(json_data).to be_a Array
        expect(json_data).to eq LittleMarketFixtures.creations
      end
    end
  end
  
end
