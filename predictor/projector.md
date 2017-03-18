### Rating a Team
#### Power Rating
  * Taken from Massey Composite
  * Converted to point value using average ratings of teams given a certain rank
#### Injury Adjustment
Point Adjustment, based on WS out with injury
  * If WS >= 1, - WS / 2.0

#### Preseason Ranking Adjustment
Point Adjustment, 7:1 weighted average of preseason rating, power rating
  * If currently rated outside max range, do nothing
  * Else, adjust to max range + 1

### Game Adjustments
#### Location
Point Adjustment, modeled after Home Court Advantage
  * Sqrt of Distance Traveled for each
  * Closer team + (MAX SQRT(distance) / SUM SQRT(Distance)) * HCA
  * TODO
  * Time Zones Traveled, Total Distance

#### Variance
Provides the standard deviation for the game
Average % of factors, put result on 7-14 scale.
  * Underdog Upset Factors
    * 3PT% & 3PT Rate - Hot 3-Point Shooting is an equalizer
    * Offensive Rebound % - Generate Extra Possessions
    * Opp TO Rate - Aggressive Play, Generate Extra Possessions
    * Tempo - Slow Play, Fewer Possessions, Higher Variance
  * Favorite Upset Factors
    * Tempo - Slow Play, Fewer Possessions, Higher Variance
    * Offensive Rebound Rate - Generate Extra Possessions
    * Consistency Rating - Ability to maintain high level of play
