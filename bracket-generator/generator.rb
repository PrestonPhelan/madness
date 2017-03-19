require_relative './team.rb'
require_relative './clash.rb'
require_relative './pod.rb'
require 'byebug'

class Hash
  def to_s
    self.each_key do |key|
      puts "#{key}: #{self[key]}"
    end
  end
end

SEED_SUMS = {
  2 => 9,
  3 => 5,
  4 => 3
}

### PHASE 1 - READ DATA ###
# Read data from CSV
teams = Team.create_all('./team_info.csv')
clashes = Clash.add_all('./matchup_rate.csv')

### PHASE 2 - INITIAL SETUP ###
# Pods variable a hash with round keys, which in turn have favorite_seed keys
# pods[round][top_seed][fav_team]
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


### PHASE 3 - ITERATE THROUGH CLASHES ###
## Initialize iteration variables
highest_round = 0
limit_reached = false
combinations_in_use = []

# until limit_reached
4.times do
  ## Read next clash
  clash = clashes.shift
  puts clash

  ## Check if pushing up highest_round
  if clash.round > highest_round
    ## Generate pods
    if highest_round == 0
      pods[1] = Hash.new
      1.upto(8) do |i|
        pods[1][i] = Hash.new
      end

      1.upto(4) do |i|
        teams[i].each do |team|
          pods[1][i][team] = []
          pods[1][i][team] << Pod.new(team, nil, 1)
        end
      end

      teams[5].each do |team|
        pods[1][5][team] = []
        pods[0][12].each_key do |team2|
          pods[0][12][team2].each do |pod|
            # next if pod.teams.any? { |team3| team3.conference == team.conference }
            pods[1][5][team] << Pod.new(team, pod, 1)
            pod.super_pods += 1
          end
        end
        pods[1][5][team] << Pod.new(team, nil, 1)
      end

      6.upto(8) do |i|
        teams[i].each do |team1|
          pods[1][i][team1] = []
          teams[17 - i].each do |team2|
            next if team1.conference == team2.conference
            pods[1][i][team1] << Pod.new(team1, team2, 1)
          end
        end
      end
    elsif highest_round == 4
      pods[5] = Hash.new
      pods[5][1] = Hash.new
      0.upto(2) do |i|
        team1 = teams[1][i]
        pods[5][1][team1] = []
        pods[4][1][team1].each do |pod1|
          (i + 1).upto(3) do |j|
            team2 = teams[1][j]
            pods[4][1][team2].each do |pod2|
              pods[5][1][team1] << Pod.new(pod1, pod2, 5)
              pod1.super_pods += 1
              pod2.super_pods += 1
            end
          end
        end
      end
    else
      top_seeds = pods[highest_round].size / 2
      this_round = highest_round + 1
      pods[this_round] = Hash.new
      1.upto(top_seeds) do |top_seed|
        # Generate pods for top_seed, which is combination of top_seed team
        # and derived opposing seed.  Check against clash test
        pods[this_round][top_seed] = Hash.new
        opposing_seed = SEED_SUMS[this_round] - top_seed
        pods[highest_round][top_seed].each_key do |team1|
          pods[this_round][top_seed][team1] = []
          pods[highest_round][top_seed][team1].each do |pod1|
            pods[highest_round][opposing_seed].each_key do |team2|
              next if team1.seed == clash.favorite && team2.seed == clash.underdog && team1.conference == team2.conference
              pods[highest_round][opposing_seed][team2].each do |pod2|
                pods[this_round][top_seed][team1] << Pod.new(pod1, pod2, this_round)
                pod1.super_pods += 1
                pod2.super_pods += 1
              end
            end
          end
        end
      end
    end
    0.upto(highest_round) do |round|
      pods[round].each_key do |k1|
        pods[round][k1].each_key do |k2|
          pods[round][k1][k2].each do |pod|
            pod.combination = nil
          end
        end
      end
    end
    combinations_in_use = []
    highest_round += 1
  else ## Else
    ## Remove pods with clashes
    ## Store these in a cache
  end
  ## End

  1.upto(8) do |i|
    count = 0
    pods[1][i].each do |_, value|
      count += value.size
    end
    puts "#{i}: #{count}"
  end


  ## Ensure combinations for each remaining pod
  ## If cannot find a combination, limit has been reached
    ## Re-add pods from cache
    ## Break loop
  ## Else reset cache to empty
end

  puts highest_round

  1.upto(4) do |i|
    count = 0
    pods[2][i].each do |_, value|
      count += value.size
    end
    puts "#{i}: #{count}"
  end
