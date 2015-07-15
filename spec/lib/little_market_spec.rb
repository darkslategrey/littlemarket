# coding: utf-8



require 'rails_helper'
require_relative '../../lib/little_market'

RSpec.describe 'LittleMarket module' do


  describe 'LittleMarket::Parser' do
    let(:noko_doc) { Nokogiri::HTML(IO.read('spec/fixtures/crea_edit_page.htm')) }
    let(:parser)   { LittleMarket::Parser.new(noko_doc) }

    it "should get the id" do
      expect(parser.get_id).to eq "15385431"
    end

    it "should get the categs" do
      categs = { cat1: "70", cat2: "70NUMERIC", cat3: nil }
      expect(parser.get_categs).to eq categs
    end
    
    it "should get the title" do
      expect(parser.get_title).to match /Programmes fait maison/
    end

    it "should get the subtitle" do
      expect(parser.get_subtitle).to match /Artisanat numérique pour vos actions sur le web/
    end

    it "should get the desc" do
      expect(parser.get_desc).to match /plus vous faire de soucis/
    end

    it "should get the tags" do
      tags = parser.get_tags
      expect(tags).to be_a Array
      expect(tags.size).to eq 2
    end

    it "should get the materials" do
      materials = parser.get_materials
      expect(materials).to be_a Array
      expect(materials.size).to eq 2
    end

    it "should get the colors" do
      colors = parser.get_colors
      expect(colors).to be_a Array
      expect(colors.size).to eq 2
    end

    it "should get the styles" do
      expect(parser.get_styles).to eq ""
    end

    it "should get the events" do
      expect(parser.get_events).to eq ""
    end

    it "should get the dest" do
      expect(parser.get_dest).to eq "UNISEX"
    end

    it "should get the prices" do
      prices = { prix_unitaire: "50.00", prix_solde: nil, quantity: "10" }
      expect(parser.get_prices).to eq prices
    end

    it "should get the deliveries" do
      deliveries = { delay: "2", profil: "924223" }
      expect(parser.get_deliveries).to eq deliveries
    end

    xit "should get the options" do
      options = { reserve: "", date: "" }
      expect(parser.get_options).to eq options
    end
    
  end

  
  describe '#get_creations' do
    
    xit 'should return the creations list from LM' do
      conn = LittleMarket::Connection.new 'lucien.farstein@gmail.com', 'toto555500'
      expect(conn.connected?).to be true
      creations = LittleMarket::Utils.get_creations
      puts creations
      expect(creations).to be
    end
    
  end
  
end
