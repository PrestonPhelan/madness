require 'distribution'
require_relative 'get_score_diff'

class MathUtil
  def self.cdf(z)
    0.0 if z < -12
    1.0 if z > 12
    0.5 if z == 0.0

    if z > 0.0
      e = true
    else
      e = false
      z = -z
    end
    z = z.to_f
    z2 = z * z
    t = q = z * Math.exp(-0.5 * z2) / Math.sqrt(2 * Math::PI)

    3.step(199, 2) do |i|
      prev = q
      t *= z2 / i
      q += t
      if q <= prev
        return(e ? 0.5 + q : 0.5 - q)
      end
    end
    e ? 1.0 : 0.0
  end
end

def win_probability(favorite, underdog)
  # Get location-adjusted ratings
  fav_name, fav_rat = favorite
  ud_name, ud_rat = underdog
  # Get standard deviation


  z_score = (fav_rat - ud_rat) / 10.5
  p_fav_win = Distribution::Normal.cdf(z_score)

  result = rand

  if result <= p_fav_win
    puts "#{fav_name} defeats #{ud_name}"
  else
    puts "#{ud_name} upsets #{fav_name}!"
  end
  puts "Result was #{result}"
  puts "Probability of favorite win was #{p_fav_win}"
  result
end

def sim(team1, team2)
  p_value = win_probability(team1[0..1], team2[0..1])
  z_score = Distribution::Normal.p_value(p_value)
  puts get_score(z_score, team1[1..2], team2[1..2])
end
#
# favorite = ["Air Force", 60.77, 71.5]
# underdog = ["Jacksonville", 57.07, 74.6]

favorite = nil
underdog = nil
while true
  puts "Enter favorite name"
  fav_name = gets.chomp
  puts "Enter favorite rating"
  fav_rat = gets.chomp.to_f
  puts "Enter favorite points per game"
  fav_ppg = gets.chomp.to_f
  puts "Enter underdog name"
  ud_name = gets.chomp
  puts "Enter underdog rating"
  ud_rat = gets.chomp.to_f
  puts "Enter underdog points per game"
  ud_ppg = gets.chomp.to_f

  favorite = [fav_name, fav_rat, fav_ppg]
  underdog = [ud_name, ud_rat, ud_ppg]

  sim(favorite, underdog)
end

# win_probability(["Air Force", 60.77], ["Jacksonville", 57.07])
