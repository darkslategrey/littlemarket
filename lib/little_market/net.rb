
require 'rest-client'

module LittleMarket

  module Connector
    
    class Net
      @@connected = true
      
      def self.login params
        RestClient.get 'http://www.littlemarket.com'
      end

      def self.get_creations_list path
        response = RestClient.get "http://www.littlemarket.com#{path}"
        response.to_str
      end

      def self.get_creation url
        response = RestClient.get url
        response.to_str
      end
      
      def self.connected?
        @@connected
      end
      
    end
  end
end
