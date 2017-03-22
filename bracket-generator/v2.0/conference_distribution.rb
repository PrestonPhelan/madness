class ConferenceDistribution
  attr_reader :conference, :region1, :region2, :region3, :region4

  def initialize(conference, regions)
    @conference = conference
    @region1, @region2, @region3, @region4 = regions
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
end
