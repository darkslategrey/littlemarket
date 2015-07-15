

class LittleMarketValidator < ActiveModel::Validator


  def validate(record)

    # Rails.logger.info "LittleMarketValidator: HAVE ERRORS #{options[:have_errors]}"
    Rails.logger.info "LittleMarketValidator: check little ids #{record.check_little_ids.class}"
    return if !record.check_little_ids 
    
    list_products_url = 'http://www.alittlemarket.com/page/creation/list.php'

    BROWSER.visit 'http://www.alittlemarket.com/'
    conn_window = BROWSER.window_opened_by  do
      BROWSER.click_on 'Se connecter'
    end
    BROWSER.within_window conn_window do
      BROWSER.fill_in 'login[username]' , :with => record.username
      BROWSER.fill_in 'login[password]',  :with => record.password
      BROWSER.click_button 'Se connecter'
    end

    err = "Vos identifiants ne sont pas reconnus par Little Market : "
    err += "#{record.username} / #{record.password}"
    record.errors[:base] << err unless BROWSER.has_text? /Bienvenue/
    
  end

  
end
