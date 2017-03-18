class Team
  attr_reader :overall, :seed, :name, :conference

  def self.create_all(filename)
    teams = Hash.new { Array.new }
    f = File.open(filename)
    f.each_line do |row|
      cells = row.split(",")
      teams[cells[1]] += [Team.new(*cells)]
    end

    teams
  end

  def initialize(*params)
    @overall = params[0].to_i
    @seed = params[1].to_i
    @name = params[2]
    @conference = params[3].strip
  end

  def to_s
    "#{@seed} #{@name} (#{@overall}), #{@conference}"
  end
end
