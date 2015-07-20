
require_relative '../../lib/little_market'

class LittleMarketValidator < ActiveModel::Validator


  def validate(record)

    Rails.logger.debug "DEBUG Validation"
    
    return if !record.check_little_ids

    params = {
      username:  record.username,
      password:  record.password,
      connector: LittleMarket::Connector::Capy
    }

    BROWSER.login params
    if not BROWSER.connected?
      Rails.logger.error "LM identification failed"
      err = "Vos identifiants ne sont pas reconnus par Little Market : "
      err += "#{record.username} / #{record.password}"
      record.errors[:base] << err
    end
    
  end

  
end
