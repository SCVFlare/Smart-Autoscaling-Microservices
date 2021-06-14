We care only about `config-map.yaml` where all jobs are described.
You can chage scrape interval for all jobs or specific jobs.
The jobs of interest are `kube-state-metrics`, `kubernetes-cadvisor`,`kubernetes-pods` and `kubernetes-nodes`

- Read PromQl basics `https://prometheus.io/docs/prometheus/latest/querying/basics/`
Metrics of interest:
- `http://localhost:30000/api/v1/query?query=sum(container_cpu_usage_seconds_total{pod="<pod name>",container!="",container!="POD"})` or `container_cpu_usage_seconds_total{pod="<pod name>",container!="",container!="POD"}` for GUI. 
This is total seconds spend on the CPU computing. it containes values for containers, pods(could have more than one container) and secret pods(we dont care about them `https://kubernetes.io/docs/concepts/configuration/secret/`) To get millicores out of this you use:

- `rate(container_cpu_usage_seconds_total{pod="<pod name>",container!="",container!="POD"}[60s])`. This looks at the last entries from the previous metric and creates a per second rate increase. If you put a smaller interval and not 60s you get holes in the graph as there needs to be 2 values at least to calclaute `rate()`. cAdvisor only reports values every 10-15 seconds(can only be chagned if we can touch cAdvisor and we can't because it hides 'behind 'kubelet')

- `kube_deployment_status_replicas_available{deployment="teastore-webui"}` is to check replicas when scaling