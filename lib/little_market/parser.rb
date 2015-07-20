
require_relative './creation_parser'
require_relative './creations_parser'

module LittleMarket
  class Parser

    def self.creation html
      html = html.class == String ? Nokogiri::HTML(html) : html
      CreationParser.new(html).extract
    end

    def self.creation_urls html
      html = html.class == String ? Nokogiri::HTML(html) : html      
      CreationsParser.new(html).edit_urls
    end

  end

end
