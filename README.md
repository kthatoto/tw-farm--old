# Termworld Farm (Old version)

## How to Run
```bash
host> $ docker build -t tw-farm-old .
host> $ docker run --rm -it tw-farm-old
```

## How to Play (Run 
```bash
# 0. List commands
docker> $ termworld

# 1. Start game worker
docker> $ termworld farming

# 2. Check status. You can see seeds and money
docker> $ termworld status

# 3. Buy 1 seed for 5 money
docker> $ termworld buy

# 4. Plant 1 seed
docker> $ termworld plant

# 5.  Check plants status, and wait a minute
docker> $ termworld check

# 6. Harvest mature plants
docker> $ termworld harvest

# Then repeat `buy` -> `plant` -> `check` -> `harvest` to earn money!
```
