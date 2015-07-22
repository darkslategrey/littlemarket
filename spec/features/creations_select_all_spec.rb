
require 'rails_helper'


describe 'Creations table on welcome page', :type => :feature do


  describe 'click select all on table' do

    it 'must select all the creations' do
      User.create :username => 'lucien.farstein@gmail.com', :password => 'toto555500'
      params = {
        username:  'lucien.farstein@gmail.com',
        password:  'toto555500',
        connector: LittleMarket::Connector::Net
      }
      visit '/'
      fill_in "user[username]", :with => "lucien.farstein@gmail.com"
      fill_in "user[password]", :with => "toto555500"
      click_button "Se connecter"
      puts page.html
      # BROWSER.set_browser LittleMarket::Connector::Net
      # LittleMarket::Connection.browser.visit '/'
    end
  end
end
