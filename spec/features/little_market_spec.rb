# coding: utf-8


require 'rails_helper'


RSpec.describe "little market", :type => :feature do 

  context "ids verifications" do 
    xit 'must display display error when cannot connect to little market' do
      visit "/user/register"
      fill_in "user[username]", :with => "lucien.farstein@gmail.com"
      fill_in "user[password]", :with => "toto55550"
      check 'user_check_little_ids'    
      click_button "S'enregister"
      expect(page).to have_content 'pas reconnus'
    end 

    xit 'must display welcome#index with correct ids' do 
      visit "/user/register"
      fill_in "user[username]", :with => "lucien.farstein@gmail.com"
      fill_in "user[password]", :with => "toto555500"
      check 'user_check_little_ids'    
      click_button "S'enregister"
      expect(page.title.strip).to eq 'Vos créations'
    end

  end

  context "when user is logged in and identified by LM" do
    let(:username) { "lucien.farstein@gmail.com" }
    let(:password) { "toto555500" }

    it "must show creations on the welcome#index page" do
      User.create! username: username, password: password
      visit "/user/login"
      fill_in "user[username]", :with => username
      fill_in "user[password]", :with => password
      click_button "Se connecter"
      expect(page.body).to match /Aucune créations/
    end
    
  end
end
