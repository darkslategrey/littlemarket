# coding: utf-8



require 'rails_helper'


describe LittleMarket::Connector::Capy do


  describe 'self.publish' do

    before do
      FactoryGirl.create :lucien
      FactoryGirl.create :jaune
      FactoryGirl.create :kaki
      FactoryGirl.create :latex
      FactoryGirl.create :velour      
      @creation = FactoryGirl.create :creation
    end
    
    let(:username) { "lucien.farstein@gmail.com" }
    let(:password) { "toto555500" }

    it 'must get the cookies' do
      params = { username: username, password: password }
      params[:connector] = LittleMarket::Connector::Capy
      BROWSER.login params

      puts "avant #{@creation.lmid}"
      resp = BROWSER.publish @creation
      puts "apres #{@creation.lmid}"      
      # puts resp.body
    end
    
  end
end
