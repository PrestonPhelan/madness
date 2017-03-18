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

  def to_s
    "#{@round}: #{@favorite}-#{@underdog}, #{@chance * 100}%"
  end
end
