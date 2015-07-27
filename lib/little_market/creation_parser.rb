

module LittleMarket

  class CreationParser

    def initialize html
      @html = html
    end
    
    def extract
      creation = {}
      [:lmid, :imgs, :categs, :title, :subtitle, :desc, :tags, :materials].each do |attr|
        begin
          creation[attr] = send "get_#{attr}".to_sym
        rescue ParseError => e
          creation[attr] = nil
        end
      end
      [:colors, :styles, :events, :dest, :prices, :deliveries, :options].each do |attr|
        begin
          creation[attr] = send "get_#{attr}".to_sym
        rescue ParseError => e
          creation[attr] = nil
        end
      end
      creation
    end
    
    def get_lmid
      xpath = '/html/body/div[2]/div/div[3]/div[1]/div[1]/div[1]/h1/div/a[2]'
      # href ex: http://www.alittlemarket.com/sell_display.php?sell_id=15385431
      begin
        @html.xpath(xpath).first.attr('href').split('=')[1]
      rescue
        raise ParseError.new("get_id error")
      end
    end

    # TODO: implement the LittleMarket::Parser.get_imgs 
    def get_imgs
    end

    def get_categs
      cat1 = @html.xpath('//select[@id="categ"]//option[@selected="selected"]')
      cat1 = cat1.empty? ? nil : cat1.first.attr('value')

      cat2 = ''
      options = @html.xpath('//select[@id="form_ssncateg"]').first
      options.children.each do |c| cat2 = c.attr('value') if c.has_attribute?('selected') end
      
      # cat2 = @html.xpath('//select[@id="form_ssncateg"]//option[@selected=""]')
      # cat2 = cat2.empty? ? nil : cat2.first.attr('value')

      cat3 = @html.xpath('//select[@id="form_ncateg3_ss"]//option[@selected="selected"]')
      cat3 = cat3.empty? ? nil : cat3.first.attr('value')

      Rails.logger.debug "DEBUG cat1 '#{cat1}' / cat2 '#{cat2}' / cat3 '#{cat3}'"

      { cat1: cat1, cat2: cat2, cat3: cat3 }
      
    end

    def get_title
      begin
        @html.xpath('//input[@id="titre"]').attribute('value').value
      rescue
        raise ParseError.new 'get_title error'
      end
    end

    def get_subtitle
      begin
        @html.xpath('//input[@id="subtitle"]').attribute('value').value
      rescue
        raise ParseError.new 'get_subtitle error'
      end
    end
    
    def get_desc
      begin
        @html.xpath('//textarea[@id="texte"]').text
      rescue
        raise ParseError.new 'get_desc error'
      end
    end

    def get_tags
      begin
        @html.css('li.tagName').map do |e| e.child.text.strip end
      rescue
        raise ParseError.new 'get_tags error'
      end
    end

    def get_materials
      begin
        @html.xpath('//div[@id="liste_matieres"]//strong').map do |e| e.text end
      rescue
        raise ParseError.new 'get_materials error'
      end
    end

    def get_colors
      begin
        @html.xpath('//div[@id="liste_colors"]//strong').map do |e| e.text end
      rescue
        raise ParseError.new 'get_colors error'
      end
    end

    def get_styles
      begin
        @html.xpath('//div[@id="liste_styles"]//strong').text
      rescue
        raise ParseError.new 'get_styles error'
      end
    end

    def get_events
      begin
        @html.xpath('//div[@id="liste_occasion"]//strong').text
      rescue
        raise ParseError.new 'get_events error'
      end
    end

    def get_dest
      begin 
        nodes_set = @html.xpath('//input[@name="destinataire"]/self::input[@checked="checked"]')
        nodes_set.first.attr('value')
      rescue
        raise ParseError.new 'get_dest error'
      end
    end

    def get_prices
      pu = @html.xpath('//input[@id="prix"]').first
      ps = @html.xpath('//input[@id="sell_prix_promo"]').first
      q  = @html.xpath('//input[@id="qte"]').first
      {
        prix_unitaire: pu.nil? ? nil : pu.attr("value"),
        prix_solde:    ps.nil? ? nil : ps.attr("value"),
        quantity:      q.nil?  ? nil : q.attr("value")
      }
    end

    def get_deliveries
      delay   = @html.xpath('//input[@id="delai"]').first
      profils = @html.xpath('//select[@id="profil"]//option[@selected="selected"]').first
      {
        delay:  delay.nil?   ? nil : delay.attr("value"),
        profil: profils.nil? ? nil : profils.attr('value')
      }
    end

    def get_options
      reserve = @html.xpath('//input[@id="pseudo_membre_reservation"]').first
      date    = @html.xpath('//input[@id="mise_en_ligne"]').first
      {
        reserve: reserve.nil? ? nil : reserve.attr('value'),
        date:    date.nil?    ? nil : date.attr('value')
      }
    end
    
  end

end
