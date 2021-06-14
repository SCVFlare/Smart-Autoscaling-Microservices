`https://github.com/kubernetes-sigs/metrics-server`
This is a version I downloaded at the time from `https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml`. To run correctly I have added args `insecure-tls` to work proeprly. 
- Check if it works with `kubectl top pod <podname>`
- Could change collection interval here?(60s->30s)
- Good explanation `https://github.com/kubernetes/community/blob/master/contributors/design-proposals/instrumentation/monitoring_architecture.md`