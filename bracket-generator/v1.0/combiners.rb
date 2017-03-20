def check_combination(pods, clashes)
  anchor = pods[1].keys.first
  opps = pods[1].keys[1..-1]
  checks = 0
  pods[1][anchor].each do |pod1|
    nil1 = pod1.teams[12].nil? ? 1 : 0
    opps.each do |team2|
      pods[1][team2].each do |pod2|
        checks += 1
        puts "Checked #{checks}" if checks % 100000 == 0
        next if clash_conflicts?(pod1, pod2, clashes)
        next if duplicate_teams?(pod1, pod2)
        nil2 = pod2.teams[12].nil? ? 1 : 0
        team3 = (opps - [team2]).first
        team4 = (opps - [team2]).last
        checks -= 1
        pods[1][team3].each do |pod3|
          checks += 1
          puts "Checked #{checks}" if checks % 100000 == 0
          next if nil1 + nil2 == 2 && pod3.teams[12].nil?
          next if duplicate_teams?(pod1, pod3) || duplicate_teams?(pod2, pod3)
          nil3 = pod3.teams[12].nil? ? 1 : 0
          checks -= 1
          pods[1][team4].each do |pod4|
            checks += 1
            puts "Checked #{checks}" if checks % 10000000 == 0
            next if nil1 + nil2 + nil3 == 2 && pod4.teams[12].nil?
            next if clash_conflicts?(pod3, pod4, clashes)
            next if duplicate_teams?(pod1, pod4) || duplicate_teams?(pod2, pod4) || duplicate_teams?(pod3, pod4)
            puts "Combination found"
            puts "Pod1"
            puts "***********************************"
            puts pod1
            puts "***********************************"
            puts "Pod2"
            puts "***********************************"
            puts pod2
            puts "***********************************"
            puts "Pod3"
            puts "***********************************"
            puts pod3
            puts "***********************************"
            puts "Pod4"
            puts "***********************************"
            puts pod4
            puts "***********************************"
            return Combination.new(5, 1, [pod1, pod2, pod3, pod4])
          end
        end
      end
    end
  end
  false
end

def clash_conflicts?(pod1, pod2, clashes)
  clashes.each do |k, v|
    return true if pod1.teams[k].first.conference == pod2.teams[v].first.conference
    return true if pod1.teams[v].first.conference == pod2.teams[k].first.conference
  end
  false
end

def duplicate_teams?(pod1, pod2)
  raise if pod1.teams[1].first == pod2.teams[1].first
  2.upto(11) do |i|
    return true if pod1.teams[i].first == pod2.teams[i].first
  end
  if !pod1.teams[12].nil? && !pod2.teams[12].nil?
    return true unless (pod1.teams[12] & pod2.teams[12]).empty?
  end
  false
end
