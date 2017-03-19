def all_pods(pods)
  result = []
  pods.each_key do |round|
    pods[round].each_key do |top_seed|
      pods[round][top_seed].each_key do |fav_team|
        result += pods[round][top_seed][fav_team]
      end
    end
  end
  result
end

def print_counts(pods)
  puts 'Current counts'
  pods.each_key do |fav_seed|
    count = 0
    pods[fav_seed].each_key do |fav_team|
      count += pods[fav_seed][fav_team].size
    end
    puts "#{fav_seed}: #{count}"
  end
end

def team_in_use?(team, search_combos)
  search_combos.each do |combo|
    return true if combo.all_pods.any? { |pod| pod.teams[team.seed] && pod.teams[team.seed].include?(team) }
  end
  false
end
