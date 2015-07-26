# coding: utf-8
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
      Creation.create!; Creation.create!
      expect(creations).to be_a Array
      expect(creations.count).to eq 2
    end
    
  end

  describe '#to_new_form' do

    xit 'should return a correct form to send' do
      params = {
        "lm_id"=>15501605,
        "imgs"=>nil,
        "categs"=>"70,,",
        "title"=>"Programmes artisanaux locaux de la région de Silicon Sentier ",
        "subtitle"=>"Facilitez vous la vie ",
        "desc"=> "Je vous propose de vous aider dans vos tâches quotidiennes et rébarbatives.\nIl existe peut être une solution automatique.\nImaginer un robot chargé de vos actions en ligne les plus pénibles et répétitives.\n\nA bientôt de vous lire. \n\nEt puis si vous êtes sur la région j'aurais le plaisir de vous la faire \ndécouvrir tout en discutant du projet qui vous amène. ",
        "tags"=>"confort  ,confortable  ,facile  ",
        "materials"=>"Latex,Velours Côtelé",
        "colors"=>"Jaune,Kaki",
        "styles"=>"",
        "events"=>"",
        "dest"=>nil,
        "prices"=>"15.00,10.00,8",
        "deliveries"=>"2,924223",
        "options"=>"toto,2015-07-30 00",
        "state"=>"published"
      }
      expect(Creation.all.count).to eq 0
      Creation.create params
      expect(Creation.all.count).to eq 1
      
    end
  end

end

