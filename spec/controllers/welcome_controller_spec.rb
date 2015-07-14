require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do

  describe "GET #index without login" do
    it "redirect to the login page" do 
      get :index
      expect(response).to redirect_to('/user/login')
    end
  end

end
