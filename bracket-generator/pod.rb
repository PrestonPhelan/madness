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
  end

  def ensure_combination
    @combination ||= find_combination
  end

  def find_combination
    # Code to return a combination that includes this pod
  end

  def get_subpods
    result = []
    return result unless @lower.is_a?(Pod)
    @upper.is_a?(Team) ? result + @lower.subpods : @upper.subpods + @lower.subpods
  end

  def get_teams
    hash = {}
    if @round == 0
      hash[12] = [@upper, @lower]
    elsif @round == 1
      hash[@favorite_seed] = @upper
      if @favorite_seed == 5
        hash[12] = @lower ? @lower.teams : nil
      else
        hash[17 - @favorite_seed] = @lower
      end
    elsif @round < 5
      @upper.teams.merge(@lower.teams)
    else
      [@upper.teams, @lower.teams]
    end
    hash
  end

  def to_s
    "#{@favorite_team}"
  end
end
