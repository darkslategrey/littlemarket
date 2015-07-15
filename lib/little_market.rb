# coding: utf-8



module LittleMarket

  PRODUCTS_URL = 'http://www.alittlemarket.com/page/creation/list.php'


  class Parser

    attr_reader :html_page

    def initialize html_page
      @html_page = html_page
    end

    def get_id
    end

    def get_imgs
    end

    def get_categs
    end

    def get_title
      @html_page.xpath('//input[@id="titre"]').attribute('value')
    end

    def get_subtitle
      @html_page.xpath('//input[@id="subtitle"]').attribute('value')      
    end
    
    def get_desc
      @html_page.xpath('//textarea[@id="texte"]').text
    end

    def get_tags
      @html_page.css('li.tagName').map do |e| e.child.text.strip end
    end

    def get_materials
      @html_page.xpath('//div[@id="liste_matieres"]//strong').map do |e| e.text end
    end

    def get_colors
      @html_page.xpath('//div[@id="liste_colors"]//strong').map do |e| e.text end      
    end

    def get_styles
      @html_page.xpath('//div[@id="liste_styles"]//strong').text
    end

    def get_events
      @html_page.xpath('//div[@id="liste_occasion"]//strong').text      
    end

    def get_dest
    end

    def get_prices
    end

    def get_deliveries
    end

    def get_options
    end
   
  end

  
  class Utils

    def self.get_creations
      hrefs     = []
      creations = []
      BROWSER.visit PRODUCTS_URL
      crea_table = Nokogiri::HTML BROWSER.html
      crea_table.xpath('//table[@id="creation"]//img[@title="Mettre à jour"]/..').each do |node|
        hrefs << node.attribute('href')
      end
      hrefs.each do |edit_url|
        BROWSER.visit edit_url
        parser = Parser.new(Nokogiri::HTML(BROWSER.html))
        creation = {}
        [:id, :imgs, :categs, :title, :subtitle, :desc, :tags, :materials].each do |attr|
          creation[attr] = parser.send "get_#{attr}".to_sym
        end
        [:colors, :styles, :events, :dest, :prices, :deliveries, :options].each do |attr|
          creation[attr] = parser.send "get_#{attr}".to_sym          
        end
        creations << creation
      end
      creations
    end
    
  end

  
  class Connection

    attr_reader :username, :password

    def initialize username, password
      @username = username
      @password = password

      BROWSER.visit 'http://www.alittlemarket.com/'
      conn_window = BROWSER.window_opened_by  do
        BROWSER.click_on 'Se connecter'
      end
      BROWSER.within_window conn_window do
        BROWSER.fill_in 'login[username]' , :with => @username
        BROWSER.fill_in 'login[password]',  :with => @password
        BROWSER.click_button 'Se connecter'
      end

      @connected = BROWSER.has_text? /Bienvenue/
      
    end


    def connected?
      @connected
    end

  end


  
end
