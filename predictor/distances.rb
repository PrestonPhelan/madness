require 'httparty'

## Constants with host locations
FIRST = {
  A: "Buffalo, NY",
  B: "Milwaukee, WI",
  C: "Orlando, FL",
  D: "Salt Lake City, UT",
  E: "Greenville, SC",
  F: "Indianapolis, IN",
  G: "Tulsa, OK",
  H: "Sacramento, CA"
}

REGIONALS = {
  A: "Kansas City, MO",
  B: "San Jose, CA",
  C: "New York, NY",
  D: "Memphis, TN"
}

FINAL = "Glendale, AZ"



#
# ## Get zip codes for host locations
# first_zips = {}
# regional_zips = {}
#
# FIRST.each do |k, v|
#   arr = v.split(", ")
#   url = "https://www.zipcodeapi.com/rest/WUOMZAFabxUleoF2HfUtKrZv5G4hYomUibGiMmtYUnj8MYbte5XZxWvCCzTAYgug/city-zips.json/#{arr[0]}/#{arr[1]}"
#   zips = HTTParty.get(url)
#   first_zips[k] = zips["zip_codes"].first
# end
#
# REGIONALS.each do |k, v|
#   arr = v.split(", ")
#   url = "https://www.zipcodeapi.com/rest/WUOMZAFabxUleoF2HfUtKrZv5G4hYomUibGiMmtYUnj8MYbte5XZxWvCCzTAYgug/city-zips.json/#{arr[0]}/#{arr[1]}"
#   zips = HTTParty.get(url)
#   regional_zips[k] = zips["zip_codes"].first
# end
#
# final_zips = HTTParty.get("https://www.zipcodeapi.com/rest/WUOMZAFabxUleoF2HfUtKrZv5G4hYomUibGiMmtYUnj8MYbte5XZxWvCCzTAYgug/city-zips.json/Glendale/AZ")
# final_zip = final_zips["zip_codes"].first
#
#
#
## Create hash with team info
teams = {}
def add_team(hash, name, location, first, region)
  hash[name] = {
    location: location,
    first: first,
    region: region
  }
  true
end

add_team(teams, "Villanova", "Philadelphia, PA", :A, :C)
add_team(teams, "Mt. St. Mary's", "Emmitsburg, MD", :A, :C)
add_team(teams, "New Orleans", "New Orleans, LA", :A, :C)
add_team(teams, "Wisconsin", "Madison, WI", :A, :C)
add_team(teams, "Virginia Tech", "Blacksburg, VA", :A, :C)
add_team(teams, "Virginia", "Charlottesville, VA", :C, :C)
add_team(teams, "UNC-Wilmington", "Wilmington, NC", :C, :C)
add_team(teams, "Florida", "Gainesville, FL", :C, :C)
add_team(teams, "ETSU", "Johnson City, TN", :C, :C)
add_team(teams, "SMU", "Houston, TX", :G, :C)
add_team(teams, "USC", "Los Angeles, CA", :G, :C)
add_team(teams, "Providence", "Providence, RI", :G, :C)
add_team(teams, "Baylor", "Waco, TX", :G, :C)
add_team(teams, "New Mexico State", "Las Cruces, NM", :G, :C)
add_team(teams, "South Carolina", "Columbia, SC", :E, :C)
add_team(teams, "Marquette", "Milwaukee, WI", :E, :C)
add_team(teams, "Duke", "Durham, NC", :E, :C)
add_team(teams, "Troy", "Troy, AL", :E, :C)
add_team(teams, "Gonzaga", "Spokane, WA", :D, :B)
add_team(teams, "South Dakota State", "Brookings, SD", :D, :B)
add_team(teams, "Northwestern", "Evanston, IL", :D, :B)
add_team(teams, "Vanderbilt", "Nashville, TN", :D, :B)
add_team(teams, "Notre Dame", "South Bend, IN", :A, :B)
add_team(teams, "Princeton", "Princeton, NJ", :A, :B)
add_team(teams, "West Virginia", "Morgantown, WV", :A, :B)
add_team(teams, "Bucknell", "Lewisburg, PA", :A, :B)
add_team(teams, "Maryland", "College Park, MD", :C, :B)
add_team(teams, "Xavier", "Cincinnati, OH", :C, :B)
add_team(teams, "Florida State", "Tallahassee, FL", :C, :B)
add_team(teams, "Florida Gulf Coast", "Fort Myers, FL", :C, :B)
add_team(teams, "St Mary's", "Moraga, CA", :D, :B)
add_team(teams, "VCU", "Richmond, VA", :D, :B)
add_team(teams, "Arizona", "Tucson, AZ", :D, :B)
add_team(teams, "North Dakota", "Grand Forks, ND", :D, :B)
add_team(teams, "Kansas", "Lawrence, KS", :G, :A)
add_team(teams, "NC Central", "Durham, NC", :G, :A)
add_team(teams, "UC Davis", "Davis, CA", :G, :A)
add_team(teams, "Miami (FL)", "Coral Gables, FL", :G, :A)
add_team(teams, "Michigan State", "East Lansing, MI", :G, :A)
add_team(teams, "Iowa State", "Ames, IA", :B, :A)
add_team(teams, "Nevada", "Reno, NV", :B, :A)
add_team(teams, "Purdue", "West Lafayette, IN", :B, :A)
add_team(teams, "Vermont", "Burlington, VT", :B, :A)
add_team(teams, "Creighton", "Omaha, NE", :H, :A)
add_team(teams, "Rhode Island", "Kingston, RI", :H, :A)
add_team(teams, "Oregon", "Eugene, OR", :H, :A)
add_team(teams, "Iona", "New Rochelle, NY", :H, :A)
add_team(teams, "Michigan", "Ann Arbor, MI", :F, :A)
add_team(teams, "Oklahoma State", "Stillwater, OK", :F, :A)
add_team(teams, "Louisville", "Louisville, KY", :F, :A)
add_team(teams, "Jacksonville State", "Jacksonville, AL", :F, :A)
add_team(teams, "North Carolina", "Chapel Hill, NC", :E, :D)
add_team(teams, "Texas Southern", "Houston, TX", :E, :D)
add_team(teams, "Arkansas", "Fayetteville, AR", :E, :D)
add_team(teams, "Seton Hall", "South Orange, NJ", :E, :D)
add_team(teams, "Minnesota", "Minneapolis, MN", :B, :D)
add_team(teams, "Middle Tennessee", "Murfreesboro, TN", :B, :D)
add_team(teams, "Butler", "Indianapolis, IN", :B, :D)
add_team(teams, "Cincinnati", "Cincinnati, OH", :H, :D)
add_team(teams, "Kansas State", "Manhattan, KS", :H, :D)
add_team(teams, "Wake Forest", "Winston-Salem, NC", :H, :D)
add_team(teams, "UCLA", "Los Angeles, CA", :H, :D)
add_team(teams, "Kent State", "Kent, OH", :H, :D)
add_team(teams, "Dayton", "Dayton, OH", :F, :D)
add_team(teams, "Wichita State", "Wichita, KS", :F, :D)
add_team(teams, "Kentucky", "Lexington, KY", :F, :D)
add_team(teams, "Northern Kentucky", "Highland Heights, KY", :F, :D)
#
# ## Get Zip Code for each team
# teams.each do |k, v|
#   arr = v[:location].split(", ")
#   url = "https://www.zipcodeapi.com/rest/WUOMZAFabxUleoF2HfUtKrZv5G4hYomUibGiMmtYUnj8MYbte5XZxWvCCzTAYgug/city-zips.json/#{arr[0]}/#{arr[1]}"
#   zips = HTTParty.get(url)
#   teams[k][:zip_code] = zips["zip_codes"].first
# end
#
# Get distance to each location
teams.each do |k, v|
  first = v[:first]
  first_round = FIRST[first].gsub(" ", "%20")
  team_location = v[:location].gsub(" ", "%20")
  url = "http://www.distance24.org/route.json?stops=#{first_round}|#{team_location}"
  first_res = HTTParty.get(url)
  teams[k][:first_distance] = first_res["distance"]
  teams[k][:first_time_diff] = first_res["travel"]["timeOffset"]["offsetMins"] / 60

  region = v[:region]
  region_location = REGIONALS[region]
  url = "http://www.distance24.org/route.json?stops=#{region_location}|#{team_location}"
  region_res = HTTParty.get(url)
  teams[k][:region_distance] = region_res["distance"]
  teams[k][:region_time_diff] = region_res["travel"]["timeOffset"]["offsetMins"] / 60

  url = "http://www.distance24.org/route.json?stops=Glendale,%20AZ|#{team_location}"
  final_res = HTTParty.get(url)
  teams[k][:final_distance] = final_res["distance"]
  teams[k][:final_time_diff] = final_res["travel"]["timeOffset"]["offsetMins"] / 60

  puts k
  puts "#{teams[k][:first_distance]}, #{teams[k][:first_time_diff]}"
  puts "#{teams[k][:region_distance]}, #{teams[k][:region_time_diff]}"
  puts "#{teams[k][:final_distance]}, #{teams[k][:final_time_diff]}"
end
#
CSV.open("./distances.csv", "wb") do |csv|
  teams.each do |k, v|
    csv << [k, v[:first_distance], v[:first_time_diff], v[:region_distance], v[:region_time_diff], v[:final_distance], v[:final_time_diff]]
  end
end
