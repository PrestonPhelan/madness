require 'httparty'

res = HTTParty.get("http://www.distance24.org/route.json?stops=San%20Francisco,%20CA|Wooster,%20OH")
puts res.keys
