require 'set'

require_relative './pod.rb'

class Set
  def to_s
    result = ""
    self.each do |el|
      result += el.to_s + ", "
    end
    result[0...-2]
  end
end

def generate_clash_map(clashes)
  result = Hash.new { |h, k| h[k] = Set.new }
  clashes.each do |clash|
    result[clash.favorite] << clash.underdog
  end
  result
end

def generate_playin_pods(teams)
  result = Hash.new
  result[12] = Hash.new

  0.upto(2) do |i|
    fav_team = teams[12][i]
    result[12][fav_team] = Set.new
    (i + 1).upto(3) do |j|
      underdog_team = teams[12][j]
      unless fav_team.conference == underdog_team.conference
        result[12][fav_team] << Pod.new(fav_team, underdog_team, 0)
      end
    end
  end

  result
end

def generate_r1_pods(teams, pods)
  # Create all first round pods, skip conference clashes
  result = Hash.new

  # Create hashes to hold pods by top seed
  1.upto(8) do |i|
    result[i] = Hash.new
  end

  # Create pods for top 4 seeds, which have nil underdogs
  1.upto(4) do |i|
    teams[i].each do |team|
      result[i][team] = Set.new
      result[i][team] << Pod.new(team, nil, 1)
    end
  end

  # Create pods for 5 seeds vs 12-seed playins & nil
  teams[5].each do |team|
    result[5][team] = Set.new
    pods[12].each_key do |team2|
      pods[12][team2].each do |pod|
        next if pod.teams[12].any? { |team3| team3.conference == team.conference }
        result[5][team] << Pod.new(team, pod, 1)
      end
    end
    result[5][team] << Pod.new(team, nil, 1)
  end

  # Create pods for 6-11, 7-10, 8-9 matchups
  6.upto(8) do |i|
    teams[i].each do |team1|
      result[i][team1] = Set.new
      teams[17 - i].each do |team2|
        next if team1.conference == team2.conference
        result[i][team1] << Pod.new(team1, team2, 1)
      end
    end
  end

  result
end

def generate_rn_pods(pods, round, clashes)
  clash_map = generate_clash_map(clashes)
  byebug
end

def generate_r5_pods(pods)

end
