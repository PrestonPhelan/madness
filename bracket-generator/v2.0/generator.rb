### PHASE 1 - READ DATA ###
# Read data from CSV
require_relative './team.rb' # Team.create_all
require_relative './clash.rb' # Clash.add_all

teams = Team.create_all('../team_info.csv')
clashes = Clash.add_all('../matchup_rate.csv')


### PHASE 2 - CREATION OF OBJECTS ###
## Create Conference Objects

## Create Conference Combinations


### PHASE 3 - INITIAL REDUCTION ###
## For each conference
  ## Move through clashes
  ## Remove combinations from its possible combination list
  ## Store these removed items in a hash pointing to the clash where it was removed
  ## Continue until one remaining, or all clashes considered


### PHASE 4 - FIND COMBINATION THAT WORKS ###
  ## Check if a combination works with conference combinations
  ## If not, re-add lowest frequency clashes
  ## Try again

### PHASE 5 - FOUND SETUP THAT WORKS ###
  ## Generate all combinations of this setup
  ## If > 1, move through overall seeds
    ## Select only combinations that offer them easiest path

  ## Return last remaining combination
