# coding: utf-8



require_relative './little_market/parser'
require_relative './little_market/connector'
require_relative './little_market/connection'

module LittleMarket;
  class LMError < Exception
    def initiliaze msg
      super msg
      Rails.logger.error e
    end
  end

  class ParseError < LMError; end
  class ConnectionError < LMError; end
  
end

