require 'capybara'
require 'capybara/poltergeist'

require_relative '../../lib/little_market'

phantomjs = RUBY_PLATFORM.include?('mingw') ? 'phantomjs.exe' : 'phantomjs'
    
Capybara.register_driver :poltergeist do |app|
  options = {
    :phantomjs => "#{Rails.root.to_s}/bin/#{phantomjs}", :js_errors => false
  }
  Capybara::Poltergeist::Driver.new(app, options)
end

# Capybara.default_max_wait_time = 5
connector = ENV['RAILS_ENV'] == 'test' ? :net : :capy
BROWSER = LittleMarket::Connection.new({ username: '', password: '', connector: connector })

