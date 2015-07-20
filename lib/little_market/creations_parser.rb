# coding: utf-8

module LittleMarket
  class CreationsParser

    def initialize html
      @html = html
    end

    def edit_urls
      @html.xpath('//table[@id="creation"]//img[@title="Mettre à jour"]/..').map do |node|
        node.attr('href')
      end
    end
    
  end
end
