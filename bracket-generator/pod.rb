class Pod
  attr_reader :upper, :lower, :round, :favorite_team, :favorite_round
  attr_accessor :combinations, :super_pods

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
  end

  def get_teams
    if @round == 1
      hash = {}
      hash[@favorite_seed] = @upper
      hash[17 - @favorite_seed] = @lower
    elsif @round < 5
      @upper.teams.merge(@lower.teams)
    else
      [@upper.teams, @lower.teams]
    end
  end
end
