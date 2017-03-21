class Clash
  attr_reader :favorite, :underdog, :round, :chance

  def self.add_all(filename)
    clashes = Array.new
    f = File.open(filename)
    f.each_line do |row|
      cells = row.split(",")
      clashes << Clash.new(*cells)
    end
    clashes
  end

  def initialize(*params)
    @favorite = params[0].to_i
    @underdog = params[1].to_i
    @round = params[2].to_i
    @chance = params[3].to_f
  end

  def count_conflicts(teams)
    count = 0
    if @favorite == @underdog
      num_teams = teams[@favorite].length
      num_teams.times do |i|
        (i + 1).upto(num_teams - 1) do |j|
          count += 1 if teams[@favorite][i].conference == teams[@favorite][j].conference
        end
      end
    else
      teams[@favorite].each do |team1|
        teams[@underdog].each do |team2|
          count += 1 if team1.conference == team2.conference
        end
      end
    end
    count
  end

  def top_seed(round = @round)
    case round
    when 1
      @favorite
    when 2
      return @favorite if @favorite <= 4
      return 9 - @favorite if @favorite <= 8
      9 - (17 - @favorite)
    when 3
      (@favorite / 2).even? ? 1 : 2
    when 4
      1
    end
  end

  def to_s
    "#{@round}: #{@favorite}-#{@underdog}, #{@chance * 100}%"
  end
end
