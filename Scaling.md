# Scaling

- Choose deplyment. Easiest WebUI as it is the frontend of the application on all requests pass through it. Choose percentage  of requested value for the deployment(More info in Teastore.md). If request value not set hpa will say ?% as it can't calculate usage.

- `kubectl autoscale deployment <teastore-deployment> --cpu-percent=50 --min=1 --max=10`

- Check if all ok `kubectl get hpa`

- Use loadgenerator:
  - change `browse.lua` with `nano browse.lua` and insert TeaStore nodeIP
  - `cd load_generation`
  - `java -jar httploadgenerator.jar loadgenerator` - call the generator in a new terminal
  - `java -jar httploadgenerator.jar director -s <director node ip> -a ./<arrivalRate.csv> -l ./<script.lua> -o <output.csv> -t 256`-call the director, you could put both on the master machine .
  - More info in LoadGeneration.md

- Execute director at the same time as a collection script. MOVE ON TO MetricsCollection.md

# Comments

- I use python to query my own localhost as everything is portforwarded but you can run them on Grid5000 as well.

- To copy files manually(better way 100%). Connect in a new terminal `ssh grenoble.g5k`. Then

- `scp root@<node name>:~/TER-2021/<file> ~/`. Then `exit`. Finally from local do:
- `scp grenoble.g5k:~/<file name> ~/<path>`

- use the `<output.csv>` with the csv-s from python script to generate graphs. More info Graphs.md

- Interpret results
