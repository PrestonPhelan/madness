require_relative './combination.rb'

class Pod
  attr_reader :upper, :lower, :round, :favorite_team, :favorite_seed, :teams, :subpods
  attr_accessor :combination, :super_pods

  def initialize(upper, lower, round)
    # TODO Solve super_pods & combinations == 0 check issues
    @upper = upper
    @lower = lower
    @round = round

    @combination = nil
    @super_pods = 0

    @favorite_team = @upper.is_a?(Team) ? @upper : @upper.favorite_team
    @favorite_seed = @upper.is_a?(Team) ? @upper.seed : @upper.favorite_seed

    @teams = get_teams
    @subpods = get_subpods
    @subpods.each do |subpod|
      next if subpod == self
      subpod.super_pods += 1
    end
  end

  def conflict?(pod)
    @teams.each_key do |i|
      next if i > 12
      if i < 12
        if pod.teams[i] && @teams[i] == pod.teams[i]
          # puts "Conflict with #{@teams[i].map(&:name)} & #{pod.teams[i].map(&:name)}"
          return true
        end
      else
        next unless @teams[i] && pod.teams[i]
        # puts "Looking for 12 seed conflict"
        # puts @teams[i].class
        # puts pod.teams[i]
        return true if !(@teams[i] & pod.teams[i]).empty?
      end
    end
    false
  end

  def remove_from(pods)
    puts "Removing #{self}"
    pods[@round][@favorite_seed][@favorite_team].delete(self)
    @subpods.each do |subpod|
      subpod.super_pods -= 1
      puts "#{subpod} Superpods: #{subpod.super_pods}"
    end
  end

  def ensure_combination(pods, teams, round)
    if round == 5
      @combination ||= find_round5_combination(pods)
    else
      @combination ||= find_combination(pods, teams, round)
    end
    @combination
  end

  def find_combination(pods, teams, round)
    # Code to return a combination that includes this pod
    # puts "Searching for combination in round #{round}"
    pods[round].each_key do |top_seed|
      # puts "Searching in #{top_seed}"
      if top_seed == @favorite_seed
        team_list = [@favorite_team]
        0.upto(3) do |i|
          next if teams[top_seed][i] == @favorite_team
          team_list << teams[top_seed][i]
        end
        team1, team2, team3, team4 = team_list
      else
        team1 = teams[top_seed][0]
        team2 = teams[top_seed][1]
        team3 = teams[top_seed][2]
        team4 = teams[top_seed][3]
      end
      pods[round][top_seed][team1].each do |pod1|
        nil_count = 0
        next unless pod1.subpods.include?(self)
        nil_count += 1 if pod1.teams[12] == nil
        pods[round][top_seed][team2].each do |pod2|
          next if pod1.conflict?(pod2)
          nil_count += 1 if pod2.teams[12] == nil
          pods[round][top_seed][team3].each do |pod3|
            next if nil_count == 2 && pod3.teams[12] == nil
            next if pod1.conflict?(pod3) || pod2.conflict?(pod3)
            nil_count += 1 if pod3.teams[12] == nil
            pods[round][top_seed][team4].each do |pod4|
              next if nil_count == 2 && pod4.teams[12] == nil
              next if pod1.conflict?(pod4) || pod2.conflict?(pod4) || pod3.conflict?(pod4)
              return Combination.new(round, top_seed, [pod1, pod2, pod3, pod4])
            end
          end
        end
        # puts "End of "
      end
    end
    puts "None found for #{self}"
    nil
  end

  def find_round5_combination(pods)
    pods[5][1].each_key do |fav_team|
      pods[5][1][fav_team].each do |pod|
        next unless pod.subpods.include?(self)
        pods[5][1].each_key do |fav_team2|
          next if pod[teams][0][1] == fav_team2 || pod[teams][1][1] == fav_team2
          pods[5][1][fav_team2].each do |pod2|
            conflict = false
            1.upto(12) do |i|
              if pod[teams][0][i] == pod2[teams][0][i] ||
                  pod[teams][0][i] == pod2[teams][1][i] ||
                  pod[teams][1][i] == pod2[teams][0][i] ||
                  pod[teams][1][i] == pod2[teams][1][i]
                conflict = true
                break
              end
            end
            return Combination.new(5, 1, [pod, pod2]) unless conflict
          end
        end
      end
    end
    nil
  end

  def get_subpods
    result = [self]
    return result unless @lower.is_a?(Pod)
    @upper.is_a?(Team) ? result + @lower.subpods : result + @upper.subpods + @lower.subpods
  end

  def get_teams
    hash = {}
    if @round == 0
      hash[12] = [@upper, @lower]
    elsif @round == 1
      hash[@favorite_seed] = [@upper]
      if @favorite_seed == 5
        hash[12] = @lower ? @lower.teams[12] : nil
      else
        hash[17 - @favorite_seed] = [@lower]
      end
    elsif @round < 5
      # puts "Getting mid-round teams..."
      return @upper.teams.merge(@lower.teams)
    else
      return [@upper.teams, @lower.teams]
    end
    hash
  end

  def to_s
    "#{@favorite_team} #{@lower}"
  end
end
