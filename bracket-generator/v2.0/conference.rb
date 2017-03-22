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
    @removed = Hash.new
  end

  def add(team)
    @teams[team.seed] = Set.new unless @teams[team.seed]
    @teams[team.seed] << team
  end

  def build_distribution(seeds, regions)
    current_seed = seeds.keys.first
    r3_r4_same = false
    if regions[3].size == regions[4].size
      r3_r4_same = true
      regions[3].each_index do |idx|
        r3_r4_same = false if regions[3][idx] != regions[4][idx]
      end
    end
    distributions = distributions(seeds[current_seed], r3_r4_same)
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

  def reduce_combinations(clashes)
    clashes.each do |clash|
      next unless @seeds[clash.favorite] > 0 && @seeds[clash.underdog] > 0
      if @seeds[clash.favorite] > 1 && @seeds[clash.underdog] > 1
        ## Double paired clash code
        clash_counts = {
          0 => Set.new,
          1 => Set.new,
          2 => Set.new
        }
        @combinations.each do |combination|
          count = combination.clash_counts(clash)
          clash_counts[count] << combination
        end
        if !clash_counts[0].empty?
          @combinations = clash_counts[0]
        elsif !clash_counts[1].empty?
          @combinations = clash_counts[1]
        else
          @combinations = clash_counts[2]
        end
      else
        new_combinations = Set.new
        @combinations.each do |combination|
          if combination.clash?(clash)
            @removed[clash] = Set.new unless @removed[clash]
            @removed[clash] << combination
          else
            new_combinations << combination
          end
        end
        if new_combinations.empty?
          @combinations = @removed[clash]
          @removed.delete(clash)
        else
          @combinations = new_combinations
        end
        break if @combinations.size == 1
      end
    end
  end

  def to_s
    "#{@name} - #{count} teams"
  end
end
