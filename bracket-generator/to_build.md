## Setup
### Create Table from CSV Import
  - [x] Object Class
    - [x] Hold name, seed, overall, conference

### Create Seed-Clash Object
  - [x] Read from CSV table
  - [x] "Clash" object

### Pods
Possible matchups.  Checking for clashes within pod.
  - [x] Tracks number of viable Combinations that include this pod
  - [x] Tracks number of viable pods next level up that include this pod
  - [x] First round is composed of team matchups, other rounds are pod matchups
  - [x] Defined by favorite

### Combinations
Combination of pods that make of the four regions.  Possible combinations without repeating teams.  Built from that round's pods
  - [ ] Tracks number of viable combinations next level up that include this combination


## Algorithm
### First Setup
  - [ ] Create team objects
  - [ ] Remove low rank-single bids
  - [ ] 12-seed Play-in Pods

### Iterate through matchups in order of probability
  - [ ] If first of round
    - [ ] Generate all possible pod matchups, minus clashes
      - [ ] Add to appropriate trackers
    - [ ] Generate combinations from possible pods
      - [ ] Add to appropriate trackers

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
