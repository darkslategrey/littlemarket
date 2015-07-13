require 'capybara'
require 'capybara/poltergeist'

phantomjs = RUBY_PLATFORM.include?('mingw') ? 'phantomjs.exe' : 'phantomjs'
    
Capybara.register_driver :poltergeist do |app|
  options = { :phantomjs => "#{Rails.root.to_s}/bin/#{phantomjs}" }
  Capybara::Poltergeist::Driver.new(app, options)
end

BROWSER = Capybara::Session.new :poltergeist

