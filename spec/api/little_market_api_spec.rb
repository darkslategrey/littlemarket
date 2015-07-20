


require 'rails_helper'
require 'pp'

require_relative '../../lib/little_market'
require_relative '../fixtures/creations'

describe LittleMarket::API, type: :feature do

  describe LittleMarket::API do

    describe 'GET /api/creations' do

      it 'return empty array of creations' do
        params = {
          username:  'lucien.farstein@gmail.com',
          password:  'toto555500',
          connector: :net
        }

        BROWSER.connector = LittleMarket::Connector::Net
        visit '/api/creations'
        json_data = JSON.parse(page.html)
        expect(page.status_code).to eq 200
        expect(json_data).to be_a Array
        expect(json_data).to eq LittleMarketFixtures.creations
      end
    end
  end
  
end
