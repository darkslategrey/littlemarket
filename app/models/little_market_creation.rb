
require_relative '../../lib/little_market'

class LittleMarketCreation

  CREAPATH   = '/page/creation/list.php'
  DELETEPATH = '/page/creation/list_action.php?action=delete&page=1&page_en_cours=1&sell_id='

  def self.delete id
    begin
      BROWSER.delete_creation id
      Creation.find_by_lm_id(id).update_attributes!({ state: 'deleted' })
    rescue Exception => e
      raise e
    end
  end

  def self.publish creation
    begin
      creation = BROWSER.publish creation
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
        params    = LittleMarket::Parser.creation BROWSER.creation(url)
        creation  = Creation.createFromLM params
        { lm_id: creation.lm_id, title: creation.title, state: creation.state }
      end
      crea_set          = Set.new creations

      # locale creations
      creations_locales = Creation.all.map do |crea|
        { lm_id: crea.lm_id, title: crea.title, state: crea.state }
      end
      crea_set.merge(Set.new(creations_locales)).to_a
    rescue LittleMarket::ParseError => e
      raise "LittleMarketCreation.all error: #{e}"
    end
  end


end



