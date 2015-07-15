

require 'rails_helper'


RSpec.describe "little market ids verifications", :type => :feature do 

  it 'must display display error when cannot connect to little market' do
    visit "/user/register"
    fill_in "user[username]", :with => "lucien.farstein@gmail.com"
    fill_in "user[password]", :with => "toto55550"
    check 'user_check_little_ids'    
    click_button "S'enregister"
    expect(page).to have_content 'pas reconnus'
  end 


  it 'must display display welcome#index with correct ids' do 
    visit "/user/register"
    fill_in "user[username]", :with => "lucien.farstein@gmail.com"
    fill_in "user[password]", :with => "toto555500"
    check 'user_check_little_ids'    
    click_button "S'enregister"
    expect(page).to have_content 'welcome index'
  end
  
end
