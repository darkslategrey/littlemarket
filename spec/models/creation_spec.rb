require 'rails_helper'
require_relative '../fixtures/creations'

RSpec.describe Creation, type: :model do
  describe "Creation#createFromLM" do

    before do
      FactoryGirl.create(:jaune)
      FactoryGirl.create(:kaki)
      @creation = FactoryGirl.create(:creation)
    end

    let(:creationLM) { LittleMarketFixtures.creations[0] }
    
    it "should build the hash param ready to post to LM" do
      form = @creation.to_new_form 
      expect(form).to be_a Hash
      expect(form["colors[]"]).to eq ["#fcea10", "#94812B"]
    end
    
    xit "should create a local creation" do
      creation = Creation.createFromLM creationLM
      expect(creation.colors).to eq 'Gris,Turquoise'
      expect(Creation.all.count).to eq 1
    end

    xit "should raise an exception when item exists and force is false" do
      Creation.createFromLM creationLM      
      expect(Creation.all.count).to eq 1
      expect{Creation.createFromLM creationLM}.to raise_error ActiveRecord::ActiveRecordError
      expect(Creation.all.count).to eq 1      
    end

    xit "should update an existing item" do
      creation_1 = Creation.createFromLM creationLM
      expect(Creation.all.count).to eq 1
      creationLM['colors'] = ['Bleu','Vert']
      creation_2 = Creation.createFromLM creationLM, force: true
      expect(Creation.all.count).to eq 1
      expect(creation_2.colors).to eq 'Bleu,Vert'
      expect(creation_1.lm_id).to eq creation_2.lm_id
    end
  end

end
