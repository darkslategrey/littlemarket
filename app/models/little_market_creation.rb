
require_relative '../../lib/little_market'

class LittleMarketCreation

  CREAPATH = '/page/creation/list.php'

  def self.all

    begin
      html      = BROWSER.creations_list CREAPATH
      creations = LittleMarket::Parser.creation_urls(html).map do |url|
        LittleMarket::Parser.creation BROWSER.creation(url)
      end
    rescue LittleMarket::ParseError => e
      raise "LittleMarketCreation.all error: #{e}"
    end
    Rails.logger.debug "CREATIONS: #{creations}"
    creations
  end

  

end
