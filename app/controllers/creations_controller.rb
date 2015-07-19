class CreationsController < ApplicationController


  def index
    @browser.visit LittleMarket::PRODUCTS_URL
    @creations = LittleMarket::Utils.get_creations @browser.html
  end
  
end
