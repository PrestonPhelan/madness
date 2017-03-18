require_relative './team.rb'
require_relative './clash.rb'
require_relative './pod.rb'

# Read data from CSV
teams = Team.create_all('./team_info.csv')
clashes = Clash.add_all('./matchup_rate.csv')

# Pods variable a hash with round keys, which in turn have favorite_seed keys
pods = Hash.new

# Build 12-seed pods
pods[0] = Hash.new
pods[0][12] = Hash.new

0.upto(3) do |i|
  pods[0][12][teams[12][i]] = []
  (i + 1).upto(3) do |j|
    pods[0][12][teams[12][i]] << Pod.new(teams[12][i], teams[12][j], 0)
  end
end
