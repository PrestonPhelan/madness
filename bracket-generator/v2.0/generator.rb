### PHASE 1 - READ DATA ###
# Read data from CSV
require_relative './team.rb' # Team.create_all
require_relative './clash.rb' # Clash.add_all
require_relative './conference.rb' # Conference.new

teams = Team.create_all('../team_info.csv')
clashes = Clash.add_all('../matchup_rate.csv')


### PHASE 2 - CREATION OF OBJECTS ###
## Create Conference Objects ##
conferences = Hash.new

teams.each do |_, team_list|
  team_list.each do |team|
    conferences[team.conference] = Conference.new(team.conference) unless conferences[team.conference]
    conferences[team.conference].add(team)
  end
end

conferences.each do |_, conference|
  conference.get_seeds
end

conferences_by_team_count = conferences.values.sort { |x, y| y.count <=> x.count }


## Create Conference Combinations ##
## For each conference
conferences_by_team_count.each do |conference|
    ## Generate all possible distributions
    ## Top seed is always region1
    ## No teams placed in region4 until a team is placed in region3
  conference.generate_all_distributions
end





### PHASE 3 - INITIAL REDUCTION ###
## For each conference
conferences_by_team_count.each do |conference|
  ## Move through clashes
  conference.reduce_combinations(clashes)
  ## Remove combinations from its possible combination list
  ## Store these removed items in a hash pointing to the clash where it was removed
  ## Continue until one remaining, or all clashes considered
end

# TODO Remove these
puts conferences_by_team_count.map { |conference| "#{conference.name} has #{conference.combinations.size} distributions" }
conferences_by_team_count.each do |conference|
  puts conference.name
  conference.combinations.each(&:print)
end

### PHASE 4 - FIND COMBINATION THAT WORKS ###
  ## Check if a combination works with conference combinations
  ## If not, re-add lowest frequency clashes
  ## Try again
  ## Possibly store checked combinations? But how?

### PHASE 5 - FOUND SETUP THAT WORKS ###
  ## Generate all combinations of this setup
  ## If > 1, move through overall seeds
    ## Select only combinations that offer them easiest path

  ## Return last remaining combination
