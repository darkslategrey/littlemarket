

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


    xit 'must display display welcome#index with correct ids' do 
      visit "/user/register"
      fill_in "user[username]", :with => "lucien.farstein@gmail.com"
      fill_in "user[password]", :with => "toto555500"
      check 'user_check_little_ids'    
      click_button "S'enregister"
      expect(page).to have_content 'welcome index'
    end

  end

  context "when user is logged in and identified by LM" do

    it "must show creations on the welcome#index page" do
      visit "/user/login"
      fill_in "user[username]", :with => "lucien.farstein@gmail.com"
      fill_in "user[password]", :with => "toto555500"
      click_button "Se connecter"
      expect(page).to have_xpath '//table/tr' 
    end
    
  end
  

end
