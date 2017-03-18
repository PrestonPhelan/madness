require 'csv'
require_relative './team'

teams = Team.read_from_csv('./team_data_pse.csv')
teams.sort! { |team1, team2| team1.slot <=> team2.slot }
#

def print_win_probability(teams, team1name, team2name, round)
  team1 = select_team(teams, team1name)
  team2 = select_team(teams, team2name)
  p_win = team1.win_probability(team2, round)
  puts team1.name + " " + p_win.to_s
  p_win
end

def select_team(teams, name)
  teams.select { |team| team.name == name }.first
end

# print_win_probability(teams, "Gonzaga", "Virginia", 5)



def get_probability_by_round(teams, round)
  teams.each do |team|
    start, finish = team.get_opponents(round)
    opponents = teams[start..finish]
    total_probability = 0
    opponents.each do |opponent|
      total_probability +=
        opponent.probabilities[round - 2] * team.win_probability(opponent, round)
    end
    if round == 1
      team.probabilities[0] = total_probability
    else
      team.probabilities[round - 1] = team.probabilities[round - 2] * total_probability
    end
    # puts team.seed.to_s + " " + team.name + " " + team.probabilities[round - 1].to_s
  end
end

1.upto(6) do |i|
  get_probability_by_round(teams, i)
end

# CSV.open("./projections_pse.csv", "wb") do |csv|
#   teams.each do |team|
#     row = [team.slot, team.seed, team.name] + team.probabilities
#     csv << row
#   end
# end

def get_conditional_probabilities(teams, name, round)
  puts "*****************"
  puts name
  puts "*****************"
  winner = select_team(teams, name)
  start, finish = winner.get_opponents(round)
  opponents = teams[start..finish]

  relative_probabilities = {}
  #Team's total probability of advancing through this round
  p_total = winner.probabilities[round - 1]
  p_arrive = winner.probabilities[round - 2]
  # puts "#{winner.name} #{p_total}"
  total_p = 0

  opponents.each do |opponent|
    opp_name = opponent.name

    p_opponent = opponent.probabilities[round - 2]
    # puts "#{opp_name} #{p_opponent}"

    p_win = winner.win_probability(opponent, round)
    # puts "#{opp_name} #{p_win}"
    p_relative = p_arrive * p_opponent * p_win / p_total

    relative_probabilities[opp_name] = p_relative
    total_p += p_relative
    # puts "#{opp_name} #{p_relative}"
  end

  # puts total_p
  puts relative_probabilities.sort_by { |k, v| v }
  # puts relative_probabilities.max_by { |k, v| v }
end

get_conditional_probabilities(teams, "Villanova", 2)
get_conditional_probabilities(teams, "Florida", 2)
get_conditional_probabilities(teams, "Baylor", 2)
get_conditional_probabilities(teams, "Duke", 2)
get_conditional_probabilities(teams, "Gonzaga", 2)
get_conditional_probabilities(teams, "West Virginia", 2)
get_conditional_probabilities(teams, "Xavier", 2)
get_conditional_probabilities(teams, "St. Mary's", 2)
get_conditional_probabilities(teams, "Kansas", 2)
get_conditional_probabilities(teams, "Purdue", 2)
get_conditional_probabilities(teams, "Rhode Island", 2)
get_conditional_probabilities(teams, "Louisville", 2)
get_conditional_probabilities(teams, "North Carolina", 2)
get_conditional_probabilities(teams, "MTSU", 2)
get_conditional_probabilities(teams, "UCLA", 2)
get_conditional_probabilities(teams, "Kentucky", 2)
