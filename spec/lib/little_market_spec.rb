# coding: utf-8



require 'rails_helper'
require 'pp'

require_relative '../../lib/little_market'

RSpec.describe 'LittleMarket module' do

  describe 'LittleMarket::CreationsParser' do
    let(:noko_doc) { Nokogiri::HTML(IO.read('spec/fixtures/mes_creations.htm')) }
    let(:parser)   { LittleMarket::CreationsParser.new(noko_doc) }

    it "should extract the edit urls" do
      urls = ['http://www.alittlemarket.com/page/creation/add.php?page_en_cours=1&action=edit&sell_id=15385431&page_en_cours=1',
              'http://www.alittlemarket.com/page/creation/add.php?page_en_cours=1&action=edit&sell_id=15353631&page_en_cours=1'
             ]
      expect(Set.new(parser.edit_urls)).to eq Set.new(urls)
    end
    
  end

  describe 'LittleMarket::CreationParser' do

    describe 'Imgs url extraction' do
      let(:noko_doc) { Nokogiri::HTML(IO.read('spec/fixtures/imgs_creation.htm')) }
      let(:parser)   { LittleMarket::CreationParser.new(noko_doc) }

      it 'should get the imgs urls' do
        host = 'http://www.alittlemarket.com'
	url1 = host + '/galerie/sell/2327013/art-numerique-programmes-artisanaux-locaux-de-la-15588075-code-space-jpg-900d-f48a1_big.jpg'
        url2 = host + '/galerie/sell/2327013/art-numerique-programmes-artisanaux-locaux-de-la-15588075-code-space-jpg-7348-682c7_big.jpg'
        expected = [{ id: '34755921', url: url1 }, { id: '34755923', url: url2 }]
        imgs_urls = parser.imgs_urls
        expect(imgs_urls).to be_a Array
        expect(imgs_urls.size).to eq 2
        expect(imgs_urls).to eq expected
      end
    end

    
    describe 'Data extraction' do
      let(:noko_doc) { Nokogiri::HTML(IO.read('spec/fixtures/crea_edit_page.htm')) }
      let(:parser)   { LittleMarket::CreationParser.new(noko_doc) }

      it "should get the id" do
        expect(parser.get_lmid).to eq "15385431"
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

      it "should get the options" do
        options = { reserve: nil, date: "0000-00-00 00" }
        expect(parser.get_options).to eq options
      end
    end
  end
end
