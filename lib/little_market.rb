# coding: utf-8



module LittleMarket

  PRODUCTS_URL = 'http://www.alittlemarket.com/page/creation/list.php'

  class CreationParser

    def initialize html
      @html = html
    end
    
    def extract
      creation = {}
      [:id, :imgs, :categs, :title, :subtitle, :desc, :tags, :materials].each do |attr|
        creation[attr] = send "get_#{attr}".to_sym
      end
      [:colors, :styles, :events, :dest, :prices, :deliveries, :options].each do |attr|
        creation[attr] = send "get_#{attr}".to_sym          
      end
      creation
    end
    
    def get_id
      xpath = '/html/body/div[2]/div/div[3]/div[1]/div[1]/div[1]/h1/div/a[2]'
      # href ex: http://www.alittlemarket.com/sell_display.php?sell_id=15385431
      @html.xpath(xpath).first.attr('href').split('=')[1]
    end

    # TODO: implement the LittleMarket::Parser.get_imgs 
    def get_imgs
    end

    def get_categs
      cat1 = @html.xpath('//select[@id="categ"]//option[@selected="selected"]')
      cat1 = cat1.empty? ? nil : cat1.first.attr('value')

      cat2 = @html.xpath('//select[@id="form_ssncateg"]//option[@selected="selected"]')
      cat2 = cat2.empty? ? nil : cat2.first.attr('value')

      cat3 = @html.xpath('//select[@id="form_ncateg3_ss"]//option[@selected="selected"]')
      cat3 = cat3.empty? ? nil : cat3.first.attr('value')

      { cat1: cat1, cat2: cat2, cat3: cat3 }
      
    end

    def get_title
      @html.xpath('//input[@id="titre"]').attribute('value')
    end

    def get_subtitle
      @html.xpath('//input[@id="subtitle"]').attribute('value')      
    end
    
    def get_desc
      @html.xpath('//textarea[@id="texte"]').text
    end

    def get_tags
      @html.css('li.tagName').map do |e| e.child.text.strip end
    end

    def get_materials
      @html.xpath('//div[@id="liste_matieres"]//strong').map do |e| e.text end
    end

    def get_colors
      @html.xpath('//div[@id="liste_colors"]//strong').map do |e| e.text end      
    end

    def get_styles
      @html.xpath('//div[@id="liste_styles"]//strong').text
    end

    def get_events
      @html.xpath('//div[@id="liste_occasion"]//strong').text      
    end

    def get_dest
      nodes_set = @html.xpath('//input[@name="destinataire"]/self::input[@checked="checked"]')
      nodes_set.first.attr('value')
    end

    def get_prices
      {
        prix_unitaire: @html.xpath('//input[@id="prix"]').first.attr("value"),
        prix_solde:    @html.xpath('//input[@id="sell_prix_promo"]').first.attr("value"),
        quantity:      @html.xpath('//input[@id="qte"]').first.attr("value")
      }
    end

    def get_deliveries
      profil_set = @html.xpath('//select[@id="profil"]//option[@selected="selected"]')
      {
        delay:  @html.xpath('//input[@id="delai"]').first.attr("value"),
        profil: profil_set.first.attr('value')
      }
    end

    def get_options
      {
        reserve: @html.xpath('//input[@id="pseudo_membre_reservation"]').first.attr('value'),
        date:    @html.xpath('//input[@id="mise_en_ligne"]').first.attr('value')
      }
    end
   
  end

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
  
  class Parser

    def self.creation html
      CreationParser.new(html).extract
    end

    def self.creation_urls html
      CreationsParser.new(html).edit_urls
    end

  end

  
  class Utils

    def self.get_creations html
      hrefs     = []
      creations = []
      # BROWSER.visit PRODUCTS_URL
      # BROWSER.html
      Parser.creation_urls(Nokogiri::HTML(html)).each do |crea_url|
        BROWSER.visit crea_url
        creations << Creation.new(Parser.creation Nokogiri::HTML(BROWSER.html))
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
