Turns queries to csv-s with my own `colectedAt` timestamp created by the script and the ones gotten by the API.
Modify to suit your own needs and metrics. Here I only get metrics-server info + nb_pods info for all pods in the system. The results are furhter treated with pandas in the graphs script.
I suggest you execute a Kubernetes API query and a Prometheus API query to see the JSON resulted format.
You cab change for loop. Now its executing every 5 sec for 12 mins

# EXAMPLE:

- just run with `python get_scaling.py` just after starting load generator director. Wait 12 mins and MOVE ON TO Graphs.md