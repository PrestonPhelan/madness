class Combination
  attr_reader :round, :top_seed, :pods, :all_pods
  attr_accessor :dependents

  def initialize(round, top_seed, pods)
    @round = round
    @top_seed = top_seed
    @pods = pods
    @all_pods = get_all_pods
    @dependents = []
  end

  def get_all_pods
    subpods = []
    @pods.each do |pod|
      subpods += pod.subpods
    end
    @pods + subpods
  end
end
