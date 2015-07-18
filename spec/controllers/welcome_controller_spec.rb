require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do

  describe "GET #index" do
    it "must redirect to the login page when not identified" do 
      get :index
      expect(response).to redirect_to('/user/login')
    end

  end



end
