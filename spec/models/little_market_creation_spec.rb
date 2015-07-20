require 'rails_helper'
require_relative '../fixtures/creations'

RSpec.describe LittleMarketCreation, type: :model do


  describe '#all' do

    it 'should yield an array of creations' do
      params     = {
        username:  'lucien.farstein@gmail.com',
        password:  'toto555500',
        connector: :net
      }
      BROWSER.connector = LittleMarket::Connector::Net
      creations  = LittleMarketCreation.all
      expect(creations).to be_a Array
    end
    
  end

end

