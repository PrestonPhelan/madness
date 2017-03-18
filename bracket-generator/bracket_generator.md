# Goal

Generate a bracket from a series of ranked teams, such to minimize conference clashes in the tournament.

# Phases

### Phase 1 - Ranking
Ranking teams based on certain principles:
  * Consensus across many rankings
    * Use harmonic mean of rankings on Massey Composite
  * Combination of best and deserving
    * Use ESPN's Strength of Record Metric
    * Total ranking is harmonic mean of Power & Strength of Record
  * Favor high conference performance in selection
    * For selection, add conference rank to total ranking.

Follow principle of seeding, where teams are ranked 1-68, then assigned
seeds.  Seeds are then treated as congruent, except in tie-break situations


### Phase 2 - Generate Bracket
* Takes in ranked list of teams, 1-68

* Eliminate conference conflicts in order of most frequent seeding matchups
until reach a conflict that cannot be avoided.  Then fill in by seed ranking.

* Seed ranking


# Future Features
### Ranking
* Pull in data automatically from Massey composite.
