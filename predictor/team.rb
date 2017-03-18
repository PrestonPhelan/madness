require_relative './math_util'
require 'byebug'

class Team
  INSTANCE_VARS = [
    :slot,
    :seed,
    :name,
    :region,
    :rating,
    :w1dist,
    :w2dist,
    :w3dist,
    :underdog,
    :favorite
  ]

  attr_accessor :probabilities
  attr_reader *INSTANCE_VARS

  def self.game_variance(favorite, underdog)
    upset_rating = ((1 - favorite.favorite) + underdog.underdog) / 2.0
    7 + 7 * upset_rating
  end

  def self.read_from_csv(filename)
    teams = []
    f = File.open(filename)
    f.each_line do |row|
      cells = row.split(",")
      teams << Team.new(*cells)
    end
    teams
  end

  def initialize(*params)
    params.each_with_index do |param, index|
      instance_variable_set("@" + INSTANCE_VARS[index].to_s, param)
    end
    @slot = @slot.to_i - 1
    @seed = @seed.to_i
    @rating = @rating.to_f
    @w1dist = @w1dist.to_i
    @w2dist = @w2dist.to_i
    @w3dist = @w3dist.to_i
    @underdog = @underdog.to_f
    @favorite = @favorite.to_f
    @probabilities = []
    @probabilities[5] = 1
  end

  def distance_by_round(round)
    if round <= 2
      @w1dist
    elsif round <= 4
      @w2dist
    else
      @w3dist
    end
  end

  def get_opponents(round)
    opp_slot = opponent_slot(round)
    slot_size = 2**(round - 1)
    start = opp_slot * slot_size
    finish = start + slot_size - 1
    [start, finish]
  end

  def opponent_slot(round)
    round_slot = own_slot(round)
    round_slot.even? ? round_slot + 1 : round_slot - 1
  end

  def own_slot(round)
    @slot / (2**(round - 1))
  end

  def travel_advantage(opponent, round)
    own_dist = Math.sqrt(distance_by_round(round))
    opponent_dist = Math.sqrt(opponent.distance_by_round(round))
    const = own_dist > opponent_dist ? -1 : 1
    total_dist = own_dist + opponent_dist
    const * [own_dist, opponent_dist].max / total_dist
  end

  def win_probability(opponent, round)
    # Get location-adjusted ratings
    own_rating = @rating + travel_advantage(opponent, round)
    opp_rating = opponent.rating
    # Get standard deviation
    favorite = own_rating > opp_rating
    variance = nil
    if favorite
      variance = Team.game_variance(self, opponent)
    else
      variance = Team.game_variance(opponent, self)
    end

    z_score = (own_rating - opp_rating) / variance
    MathUtil.cdf(z_score)
  end
end
