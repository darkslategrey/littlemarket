require 'rails_helper'

RSpec.describe Color, type: :model do

  describe "#find_by_names" do

    before do
      FactoryGirl.create(:jaune)
      FactoryGirl.create(:kaki)
    end
    
    it "should return an array of hex code" do
      expect(Color.find_by_names("Jaune, Kaki")).to eq ["#fcea10", "#94812B"]
    end
    
  end
  
end
