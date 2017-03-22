class ConferenceDistribution
  attr_reader :conference, :region1, :region2, :region3, :region4

  def initialize(conference, regions)
    @conference = conference
    @region1, @region2, @region3, @region4 = regions
  end

  def clash?(clash)
    if clash.round == 5
      region_pairs.any? { |pair| paired_clash(pair, clash) }
    else
      regions.any? do |region|
        region_clash?(region, clash)
      end
    end
  end

  def clash_counts(clash)
    count = 0
    if clash.round == 5
      region_pairs.each do |pair|
        count += 1 if paired_clash(pair, clash)
      end
      count
    else
      regions.each do |region|
        count += 1 if region_clash?(region, clash)
      end
      count
    end
  end

  def paired_clash(pair, clash)
    pair[0].include?(clash.favorite) && pair[1].include?(clash.underdog) ||
    pair[0].include?(clash.underdog) && pair[1].include?(clash.favorite)
  end

  def print
    puts "1: #{print_region(@region1)},
      2: #{print_region(@region2)},
      3: #{print_region(@region3)},
      4: #{print_region(@region4)}"
  end

  def print_region(region)
    result = "["
    region[0...-1].each do |num|
      result << num.to_s
      result += ", "
    end
    result += region[-1].to_s
    result += "]"
  end

  def regions
    [@region1, @region2, @region3, @region4]
  end

  def region_clash?(region, clash)
    region.include?(clash.favorite) && region.include?(clash.underdog)
  end

  def region_pairs
    [[@region1, @region2], [@region3, @region4]]
  end
end
