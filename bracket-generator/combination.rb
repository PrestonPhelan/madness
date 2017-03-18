class Combination
  attr_reader :round, :top_seed, :pods

  def initialize(round, top_seed, pods)
    @round = round
    @top_seed = top_seed
    @pods = pods
  end
end
