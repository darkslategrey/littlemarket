
require_relative '../../lib/little_market'

class LittleMarketCreation

  CREATIONS_PATH = '/page/creation/list.php'

  def self.all
    BROWSER.click_on 'a Mon compte'
    Capybara.app_host = 'http://www.alittlemarket.com'
    BROWSER.visit '/page/creation/list.php'

    begin
      creations = LittleMarket::Parser.creation_urls(BROWSER.html).map do |url|
        BROWSER.visit url
        LittleMarket::Parser.creation BROWSER.html
      end
    rescue LittleMarket::ParseError => e
      raise "LittleMarketCreation.all error: #{e}"
    end
    Rails.logger.debug "CREATIONS: #{creations}"
    creations
  end

  

end
