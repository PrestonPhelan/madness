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
