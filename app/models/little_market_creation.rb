
require_relative '../../lib/little_market'

class LittleMarketCreation

  CREAPATH   = '/page/creation/list.php'
  DELETEPATH = '/page/creation/list_action.php?action=delete&page=1&page_en_cours=1&sell_id='

  def self.delete id
    begin
      BROWSER.delete_creation id
      Creation.find_by_lmid(id).update_attributes!({ state: 'deleted' })
    rescue Exception => e
      raise e
    end
  end

  def self.publish creation
    begin
      BROWSER.publish creation
      creation.update_attributes! state: 'published'
    rescue Exception => e
      raise e
    end
  end


  def self.all

    begin
      html        = BROWSER.creations_list CREAPATH
      # remote creations
      creations   = LittleMarket::Parser.creation_urls(html).map do |url|
        crea_html = BROWSER.creation(url)
        params    = LittleMarket::Parser.creation crea_html
        creation  = Creation.createFromLM params
        imgs_params = []
        i = 0
        LittleMarket::Parser.imgs(crea_html).each do |img_url|
          imgs_params << BROWSER.img(img_url[:url], creation.id, i)
          i += 1
        end
        creation.update_attribute :imgs, imgs_params.join(',')
        { lmid: creation.lmid, title: creation.title, state: creation.state }
      end
      crea_set          = Set.new creations

      # locale creations
      creations_locales = Creation.all.map do |crea|
        { lmid: crea.lmid, title: crea.title, state: crea.state }
      end
      crea_set.merge(Set.new(creations_locales)).to_a
    rescue LittleMarket::ParseError => e
      raise "LittleMarketCreation.all error: #{e}"
    end
  end


end



