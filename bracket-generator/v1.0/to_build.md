## Setup
### Create Table from CSV Import
  - [x] Object Class
    - [x] Hold name, seed, overall, conference

### Create Seed-Clash Object
  - [x] Read from CSV table
  - [x] "Clash" object

### Pods
Possible matchups.  Checking for clashes within pod.
  - [x] Tracks a viable Combination that includes this pod
  - [x] Tracks number of viable pods next level up that include this pod
  - [x] First round is composed of team matchups, other rounds are pod matchups
  - [x] Defined by favorite

### Combinations
Combination of pods that make of the four regions.  Possible combinations without repeating teams.  Built from that round's pods
  - [x] Built
  - [ ] Accounts for 12-seed Play-ins

## Algorithm
### First Setup
  - [x] Create team objects
    - [x] Skip low rank-single bids
  - [x] 12-seed Play-in Pods

### Iterate through matchups in order of probability
  - [ ] If first of round
    - [x] Generate all possible pod matchups, minus clashes
      - [x] Add to appropriate trackers
    - [x] Reset all combinations
    - [ ] Find new combinations
      - [ ] Add to list

  - [ ] Else
    - [ ] Find a combination with no clashes.  If it exists, limit has not been found.
      - [ ] Find clashes, remove all pods
      - [ ] At each removal, find all higher level pods and remove those. Track those pods
      - [ ] Remove combinations that include removed pods
        - [ ] Start at lowest level, move up
    - [ ] If not, Limit has been found, break

### After Limit Is Found
  - [ ] Move from number 1 overall seed down
  - [ ] Find pod that has the lowest-seeded favorites
  - [ ] Reduce to combinations that only include those pods.
  - [ ] Continue until only one overall combination remains.
