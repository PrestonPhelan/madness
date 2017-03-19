require_relative './pod.rb'

def generate_playin_pods(teams)
  result = Hash.new
  result[12] = Hash.new

  0.upto(2) do |i|
    fav_team = teams[12][i]
    result[12][fav_team] = []
    (i + 1).upto(3) do |j|
      result[12][fav_team] << Pod.new(fav_team, teams[12][j], 0)
    end
  end

  result
end

def generate_pods(pods, round)
  if round == 5
    generate_r5_pods(pods)
  else
    generate_rn_pods(pods, round)
  end
end

def generate_r1_pods(teams, pods)

end

def generate_rn_pods(pods, round)

end

def generate_r5_pods(pods)

end
