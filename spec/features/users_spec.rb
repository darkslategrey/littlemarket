# coding: utf-8
require 'rails_helper'


RSpec.describe "users requests page", :type => :feature do 

  it "displays the welcome#index after successful login" do
    User.create :username => "jdoe", :password => "secret"
    visit "/user/login"
    fill_in "user[username]", :with => "jdoe"
    fill_in "user[password]", :with => "secret"
    click_button "Se connecter"
    expect(page.title.strip).to eq 'Vos créations'
  end

  it "displays the welcome#index after user registration" do
    visit "/user/register"
    fill_in "user[username]", :with => "jdoe"
    fill_in "user[password]", :with => "secret"
    click_button "S'enregister"
    expect(page.title.strip).to eq 'Vos créations'    
  end

  it "must display errors when missing required infos" do 
    visit "/user/register"
    fill_in "user[username]", :with => ""
    fill_in "user[password]", :with => ""
    click_button "S'enregister"
    expect(page).to have_content 'fournir'
  end


  it "must display error when duplicate email is detected" do
    FactoryGirl.create(:user, :username => "jdoe", :password => "secret")    
    visit "/user/register"
    fill_in "user[username]", :with => "jdoe"
    fill_in "user[password]", :with => "secret"
    click_button "S'enregister"
    expect(page).to have_content 'déjà enregistré'
  end

 
end

