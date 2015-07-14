require 'rails_helper'


RSpec.describe "login page", :type => :feature do
  it "displays the welcome#index after successful login" do
    user = FactoryGirl.create(:user, :username => "jdoe", :password => "secret")
    visit "/user/login"
    fill_in "user[username]", :with => "jdoe"
    fill_in "user[password]", :with => "secret"
    click_button "Se connecter"
    expect(page).to have_content 'welcome index'
  end
end

