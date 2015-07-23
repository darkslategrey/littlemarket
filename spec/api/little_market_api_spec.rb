


require 'rails_helper'
require 'pp'

require_relative '../../lib/little_market'
require_relative '../fixtures/creations'

describe LittleMarket::API, type: :feature do

  describe LittleMarket::API do

    describe 'GET /api/creations/delete' do

      it 'must delete the creation from LM' do
        visit '/api/creations/delete?lm_id=10'
        # http://www.alittlemarket.com/page/creation/list_action.php?action=delete&page=1&sell_id=15353631&page_en_cours=1
        expect(page.status_code).to eq 200
      end
      
    end
    
    describe 'GET /api/creations' do

      it 'return an array of creations' do
        params = {
          username:  'lucien.farstein@gmail.com',
          password:  'toto555500',
          connector: LittleMarket::Connector::Net
        }

        # BROWSER.connector = 
        BROWSER.login params
        visit '/api/creations'
        json_data = JSON.parse(page.html)
        expect(page.status_code).to eq 200
        expect(json_data).to be_a Array
        expect(json_data).to eq LittleMarketFixtures.creations
      end
    end
  end
  
end
