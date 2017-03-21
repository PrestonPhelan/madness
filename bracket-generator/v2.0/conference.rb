require 'set' #Set.new for combinations

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

  def count
    #TODO Need this anywhere?
    result = 0
    @teams.each { |_, team_list| result += team_list.size }
    result
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
