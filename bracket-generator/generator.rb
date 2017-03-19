require_relative './team.rb'
require_relative './clash.rb'
require_relative './pod.rb'
require_relative './builders.rb'
require_relative './util.rb'
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
# Pods variable a hash, keyed by favorite_seed, sub-keys favorite team
# pods[top_seed][fav_team] => Set of pods

# Initially set to the group of play-in pods
pods = generate_playin_pods(teams)
print_counts(pods)

# Generate first round pods
pods = generate_r1_pods(teams, pods)
print_counts(pods)

## Initialize iteration variables
limit_reached = false
p_limit_reached = false
highest_round = 1
clashes_checked = 0
# combinations_in_use = []
# orphans = []
# conflict_pods = []
# combinations_to_remove = []

### PHASE 3 - ITERATE THROUGH CLASHES ###
# Iterate until no possible combinations avoid the clash & you're reached matchups
# with a less than 5% chance of happening
until limit_reached && p_limit_reached
# 3.times do

  ## Read next clash
  clash = clashes.shift
  clashes_checked += 1
  puts "Check number #{clashes_checked}: #{clash}"
  if clash.chance < 0.05 && !p_limit_reached
    puts "Reached 5% threshold"
    p_limit_reached = true
  end

  # Skip round 1 conflicts
  if clash.round == 1
    puts "Skipping round 1 conflict"
    next
  end
  ## Skip if there are no conflicts
  if clash.count_conflicts(teams) == 0
    puts "No conflicts in #{clash}"
    next
  end

  ## Check if pushing up highest_round
  if clash.round > highest_round
    puts "Building pods for round #{highest_round + 1}"

    # Grab all clashes from that round that are coming next
    clashes_to_check = Set.new
    clashes_to_check << clash
    until clashes.first.round != clash.round
      next_clash = clashes.shift
      clashes_checked += 1
      if next_clash.count_conflicts(teams) == 0
        puts "No conflicts for #{next_clash}"
        next
      end
      puts "Also checking #{next_clash}"
      clashes_to_check << next_clash
    end

    puts "Passing #{clashes_to_check.length} clashes to generator function"
    # byebug
    if highest_round == 4
      pods = generate_r5_pods(pods)
    else
      pods = generate_rn_pods(pods, highest_round + 1, clashes_to_check)
      print_counts(pods)
    end
    byebug

    ## Special case, pods for national semifinals
    if highest_round == 4
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
            end
          end
        end
      end

    ## Normal case
    else
      top_seeds = pods[highest_round].size / 2
      this_round = highest_round + 1
      puts "Building pods for round #{this_round}"
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
              end
            end
          end
        end
      end
      # pods[2][4].each_key do |team|
      #   puts pods[2][4][team]
      # end
      pods[1].each_key do |seed|
        pods[1][seed].each_key do |team|
          pods[1][seed][team].each do |pod|
            puts "#{pod} Superpods: #{pod.super_pods}"
          end
        end
      end
    end

    ## Reset all combinations in pods to nil
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

    ## Advance highest roud
    highest_round += 1

    ## Generate new combinations
    if highest_round >= 2
      highest_round.downto(1) do |round|
        pods[round].each_key do |top_seed|
          pods[round][top_seed].each_key do |fav_team|
            pods[round][top_seed][fav_team].each do |pod|
              combo = pod.ensure_combination(pods, teams, highest_round)
              if combo
                combo.all_pods.each do |subpod|
                  unless subpod.combination
                    subpod.combination = combo
                    combo.dependents << subpod
                  end
                end
                combinations_in_use << combo
              else
                orphans << pod
              end
            end
            until orphans.empty?
              puts "Orphans found: #{orphans.length}"
              dead_pod = orphans.shift
              dead_pod.remove_from(pods)
            end
          end
        end
      end
    end
    ## Remove orphans


  else ## Else
    ## Remove pods with clashes
    pods[clash.round][clash.top_seed].each_key do |fav_team|
      puts "Pods to search: #{pods[clash.round][clash.top_seed][fav_team].size}"
      pods[clash.round][clash.top_seed][fav_team].each do |pod|
        # puts "Clash favorite teams #{pod.teams[clash.favorite]}"
        # puts "Clash underdog teams #{pod.teams[clash.underdog]}"
        if pod.teams[clash.favorite] && pod.teams[clash.underdog] && !(pod.teams[clash.favorite].map(&:conference) & pod.teams[clash.underdog].map(&:conference)).empty?
        # if pod.teams[clash.underdog].any? { |team2| team2 && team.conference == team2.conference }
          puts "Found conflict"
          puts "Clash between #{pod.teams[clash.favorite]} & #{pod.teams[clash.underdog]}"
          ## Store these in a cache
          conflict_pods << pod
          ## Remove all pods above current pod that include current pod
          highest_round.downto(clash.round + 1) do |round|
            pods[round][clash.top_seed(round)].each_key do |fav_team2|
              pods[round][clash.top_seed(round)][fav_team2].each do |superpod|
                # Store in cache as well
                conflict_pods << superpod if superpod.subpods.include?(pod)
              end
            end
          end
        end
      end
      conflict_pods.length.times do
        pod = conflict_pods.shift
        pod.remove_from(pods)
      end
    end


    if highest_round > 1
      all_pods(pods).each do |pod|
        next if pod.round == highest_round
        raise "#{pod} has less than 0 super_pods" if pod.super_pods < 0
        orphans << pod if pod.super_pods == 0
      end

      puts conflict_pods

      orphans << "dummy"
      until orphans.empty?
        puts "Orphans exist"
        until orphans.empty?

          orphans.delete("dummy")
          dead_pod = orphans.shift
          if dead_pod
            dead_pod.remove_from(pods)
            dead_pod.subpods.each do |subpod|
              orphans << subpod if subpod.super_pods == 0
            end
            conflict_pods << dead_pod
          end
        end

        combinations_in_use.each do |combination|
          if !(combination.all_pods & conflict_pods).empty?
            puts "Removing a combination..."
            combinations_to_remove << combination
            combinations_in_use.delete(combination)
          end
        end

        all_pods(pods).each do |pod|
          combo = pod.ensure_combination(pods, teams, highest_round)
          if combo
            combo.all_pods.each do |subpod|
              unless subpod.combination
                subpod.combination = combo
                combo.dependents << subpod
              end
            end
            combinations_in_use << combo
          else
            orphans << pod
          end
        end
      end
    end
  end
  ## End


  ## Ensure combinations for each remaining pod
  ## If cannot find a combination, limit has been reached
    ## Re-add pods from cache
    ## Break loop
  ## Else reset cache to empty
  if highest_round > 1
    teams.each_key do |seed|
      teams[seed].each do |team|
        unless team_in_use?(team, combinations_in_use)
          limit_reached = true
          break
        end
      end
    end
  end
end

puts highest_round


puts "Combinations in use: #{combinations_in_use.length}"
puts "Clashes checked: #{clashes_checked}"
