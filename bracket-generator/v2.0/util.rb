require 'set'

def add_distribution(regions, seed, distribution)
  new_regions = Hash.new
  regions.each do |num, arr|
    new_regions[num] = Array.new
    arr.each do |seed_num|
      new_regions[num] << seed_num
    end
  end
  if distribution.is_a?(Array)
    distribution.each do |region|
      new_regions[region] << seed
    end
  else
    new_regions[distribution] << seed
  end
  new_regions
end

def build_bracket(bracket, conferences)
  current = conferences.first
  current.combinations.each do |combination|
    fits = fit_maps(bracket, combination)
    next if fits.empty?
    fits.each do |fit|
      new_bracket = combine(bracket, combination, fit)
      return new_bracket if conferences.size == 1
      built_bracket = build_bracket(new_bracket, conferences[1..-1])
      return built_bracket if built_bracket
    end
  end
  nil
end

def combine(bracket, combination, fit_map)
  #Builds new bracket based on instructions from fit map
  new_bracket = dup_bracket(bracket)
  fit_map.each do |fit_reg, bracket_reg|
    region = combination.regions[fit_reg - 1]
    region.each do |seed|
      new_bracket[bracket_reg][seed] << combination.conference
    end
  end
  new_bracket
end

def fit_maps(bracket, combination)
  #Returns all possible way a bracket and a combination can fit together
  #Key will be combination region, value will be bracket region
  general_fits = {
    1 => Set.new,
    2 => Set.new,
    3 => Set.new,
    4 => Set.new
  }
  maps = []

  combination.regions.each_index do |idx|
    bracket.each do |reg, _|
      general_fits[idx + 1] << reg if fit?(combination.regions[idx], bracket, reg)
    end
    return maps if general_fits[idx + 1].empty?
  end

  1.upto(4) do |i|
    return maps unless general_fits.values.any? { |match| match.include?(i) }
  end

  general_fits[1].each do |match1|
    used1 = [match1]
    general_fits[2].each do |match2|
      next if used1.include?(match2)
      next unless [match1, match2].sort == [1, 2] || [match1, match2].sort == [3, 4]
      used2 = [match1, match2]
      general_fits[3].each do |match3|
        next if used2.include?(match3)
        used3 = [match1, match2, match3]
        general_fits[4].each do |match4|
          next if used3.include?(match4)
          maps << {
            1 => match1,
            2 => match2,
            3 => match3,
            4 => match4
          }
        end
      end
    end
  end

  maps
end

def fit?(combination_region, bracket, reg_num)
  # Returns true if there are no conflicts
  # combination_region is list of seeds
  combination_region.each do |seed_num|
    if seed_num < 11
      # puts bracket
      return false if bracket[reg_num][seed_num] && !bracket[reg_num][seed_num].empty?
    else
      return false if bracket[reg_num][11] && bracket[reg_num][11].size == 2
      count = 0
      bracket.each do |reg, _|
        next if reg == reg_num
        count += 1 if bracket[reg][11] && bracket[reg][11].size == 2
      end
      return false if count == 2
      raise "12 seeds too spread out!" if count > 2
    end
  end
end


def distributions(n, three_empty)
  if n == 1
    three_empty ? [1, 2, 3] : [1, 2, 3, 4]
  elsif n == 2
    if three_empty
      [
        [1, 2],
        [1, 3],
        [2, 3],
        [3, 4]
      ]
    else
      [
        [1, 2],
        [1, 3],
        [1, 4],
        [2, 3],
        [2, 4],
        [3, 4]
      ]
    end
  else
    raise "Can't handle that many seeds on the same line"
  end
end

def find_combination(conferences)
  ## Outer conference loop
  start = conferences.first
  count = 0
  latest_built = nil
  start.combinations.each do |combination|
    bracket = {
      1 => Hash.new,
      2 => Hash.new,
      3 => Hash.new,
      4 => Hash.new
    }

    combination.regions.each_with_index do |region, idx|
      region.each do |seed|
        bracket[idx + 1][seed] = [start.name]
      end
    end

    built_bracket = build_bracket(bracket, conferences[1..-1])
    if built_bracket && correct_11s?(built_bracket)
      count += 1
      latest_built = built_bracket
    end
  end
  return nil if count == 0
  [latest_built, count]
end

def dup_bracket(bracket)
  result = {
    1 => Hash.new,
    2 => Hash.new,
    3 => Hash.new,
    4 => Hash.new
  }
  result.each do |_, seed_map|
    1.upto(11) do |i|
      seed_map[i] = Array.new
    end
  end

  bracket.each do |reg, seed_map|
    seed_map.each do |seed, list|
      list.each do |el|
        result[reg][seed] << el
      end
    end
  end

  result
end

def correct_11s?(bracket)
  puts bracket
  bracket.each do |reg, seed_list|
    elevens = seed_list[11]
    return false if elevens.size == 1 && (elevens.first == "Pac-12" || elevens.first == "ACC" || elevens.first == "Big 12")
    return false if elevens.size == 2 && elevens.include?("A10")
  end
  true
end
