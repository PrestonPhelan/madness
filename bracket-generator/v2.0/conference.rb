require 'set' #Set.new for combinations

require_relative 'conference_distribution.rb' #ConferenceDistribution.new
require_relative 'util.rb' #distributions


class Conference
  attr_accessor :combinations, :teams
  attr_reader :name, :seeds

  def initialize(name)
    @name = name
    @teams = Hash.new
    @combinations = Set.new
  end

  def add(team)
    @teams[team.seed] = Set.new unless @teams[team.seed]
    @teams[team.seed] << team
  end

  def build_distribution(seeds, regions)
    current_seed = seeds.keys.first
    distributions = distributions(seeds[current_seed], regions[3].empty?)
    if seeds.size == 1
      distributions.each do |distribution|
        new_regions = add_distribution(regions, current_seed, distribution)
        @combinations << ConferenceDistribution.new(
          @name,
          [
            new_regions[1],
            new_regions[2],
            new_regions[3],
            new_regions[4]
          ])
      end
      return
    else
      distributions.each do |distribution|
        new_regions = add_distribution(regions, current_seed, distribution)
        build_distribution(
          seeds.reject { |k, _| k == current_seed },
          new_regions)
      end
    end
  end

  def count
    #TODO Need this anywhere?
    result = 0
    @teams.each { |_, team_list| result += team_list.size }
    result
  end

  def generate_all_distributions
    seed_nums = @seeds.keys.sort
    raise if @seeds[seed_nums.first] > 1
    first_num = seed_nums.first
    regions = {
      1 => [first_num],
      2 => [],
      3 => [],
      4 => []
    }
    if @seeds.size > 1
      build_distribution(@seeds.reject { |k, _| k == first_num }, regions)
    else
      @combinations << ConferenceDistribution.new(
      @name,
      [
        regions[1],
        regions[2],
        regions[3],
        regions[4]
        ])
    end
  end

  def get_seeds
    result = Hash.new(0)
    @teams.each do |seed, teams|
      result[seed] = teams.size
    end
    @seeds = result
  end

  def to_s
    "#{@name} - #{count} teams"
  end
end
