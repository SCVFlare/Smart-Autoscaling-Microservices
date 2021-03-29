kubectl create -f https://raw.githubusercontent.com/cilium/cilium/v1.6/install/kubernetes/quick-install.yaml
kubectl create -f https://raw.githubusercontent.com/SCVFlare/TER-2021/main/metrics-server.yaml
kubectl create -f https://github.com/SCVFlare/TER-2021/tree/main/kube-state-metrics
kubectl create namespace monitoring
kubectl create -f https://github.com/SCVFlare/TER-2021/tree/main/prometheus
kubectl create -f https://github.com/SCVFlare/TER-2021/tree/main/grafana
kubectl create -f https://raw.githubusercontent.com/SCVFlare/TER-2021/main/metrics-server-exporter.yaml
kubectl create -f https://raw.githubusercontent.com/DescartesResearch/TeaStore/master/examples/kubernetes/teastore-clusterip.yaml