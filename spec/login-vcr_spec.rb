require 'rails_helper'
# require 'test/unit'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_k7"
  config.hook_into :webmock # or :fakeweb
end


describe 'login process' do

  xit 'must log' do
    url      = 'https://api-user.alittleincubart.com/fr/login-check'
    username = 'lucien.farstein@gmail.com'
    password = 'toto555500'
    params   = { 'login["username"]' => username, 'login["password"]' => password }

    VCR.use_cassette("login") do
      response = RestClient.post url, params
      puts response.body
      # response = Net::HTTP.get_response(URI('http://www.iana.org/domains/reserved'))
      # assert_match /Example domains/, response.body
    end

  end
end

# class VCRTest < Test::Unit::TestCase
#   def test_example_dot_com

#   end
# end



