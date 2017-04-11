def get_score(z_score, favorite, underdog)
  fav_rat, fav_ppg = favorite
  ud_rat, ud_ppg = underdog
  score_diff = score_diff(z_score, fav_rat, ud_rat).round
  puts "Score diff should be #{score_diff}"
  nat_dif = fav_ppg.round - ud_ppg.round
  adj_needed = (score_diff - nat_dif).floor
  boost = rand(20) - 10
  # puts "Favorite Score: #{fav_ppg.round + adj_needed / 2 + boost}"
  # puts "Underdog Score: #{ud_ppg.round - adj_needed / 2 + boost}"
  # puts "Boost was #{boost}"
  [fav_ppg.round + adj_needed / 2 + boost, ud_ppg.round - adj_needed / 2 + boost, score_diff]
end

def score_diff(z_score, fav_rat, ud_rat)
  res = (z_score * 10.5 + (fav_rat - ud_rat))
  puts res
  res
end

# puts get_score(1.29, [60.77, 71.5], [57.07, 74.6])
