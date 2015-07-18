class WelcomeController < ApplicationController
  before_filter :login_required
  
  def index

    @browser.visit LittleMarket::PRODUCTS_URL
    @creations = LittleMarket::Utils.get_creations @browser.html
                  
  end

  
end
