require 'faraday'
require 'faraday-cookie_jar'
require 'faraday_middleware'
require 'pry'

# http_conn = Faraday.new do |builder|
#   builder.adapter Faraday.default_adapter
#   builder.use FaradayMiddleware::FollowRedirects, limit: 3  
# end




# response = http_conn.get do |req|
#   req.url url
#   req.headers['Cache-Control'] = 'max-age=0'
#   req.headers['User-Agent']    = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/538.1 (KHTML, like Gecko) qutebrowser/0.2.1 Safari/538.1'
#   # req.headers['Accept']        = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
#   req.headers['Accept'] = 'image/jpeg'
# end 

# pry.binding

host =  'http://www.alittlemarket.com'
host = 'http://galerie.alittlemarket.com'

conn = Faraday.new(:url => host) do |faraday|
  faraday.request  :url_encoded             # form-encode POST params
  faraday.response :logger                  # log requests to STDOUT
  faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
  faraday.use FaradayMiddleware::FollowRedirects, limit: 3    
end


url = '/galerie/sell/2327013/art-numerique-programmes-artisanaux-locaux-de-la-15588075-code-space-jpg-900d-f48a1_big.jpg'

puts host + url

response = conn.get url

File.open('img.jpg', 'w') do |f|
  f.write response.body
end

# pry.binding
