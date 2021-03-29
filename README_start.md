# Getting started with Kubernetes on Grid 5000, Teastore and metrics collection
## Grid 5000 steps
 - Check <sup>6</sup> for example ssh config to connect easily. Normally in folder `~/.ssh/config`
 - Reserve a two nodes in interactive node for 2 hours for example whit option deploy  
 `oarsub -I -l nodes=2,walltime=2 -t deploy`
 - When connected<sup>1</sup>, deploy an image of Debain-std(-std because -base doesn't provide any commands or pre-installed software), using  
 `kadeploy3 -f $OAR_NODE_FILE -e debian10-x64-std -k`
 - The process takes couple of minutes, then connect to the master<sup>2</sup> machine with  
`ssh root@<machine_name>`

## Master
- Then run the already given docker setup with  
`sudo-g5k /grid5000/code/bin/g5k-setup-docker`  
- do these(don't know why):  
   - `systemctl stop docker`
   - `mv /var/lib/docker /tmp/docker`
   - `ln -s /tmp/docker/ /var/lib/docker`
   - `systemctl start docker`
- update sources  
`sudo apt-get update && sudo apt-get install -y apt-transport-https curl`  
- add key  
`curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -`  
- add source for kubernetes  
`echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list`  
- update, install and hold kubernetes  
   - `sudo apt-get update`
   - `sudo apt-get install -y kubelet kubeadm kubectl`
   - `sudo apt-mark hold kubelet kubeadm kubectl`
- preparatory config steps  
   - `kubeadm config images pull`  
   - `sed -i 's#Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=systemd"#Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=cgroupfs"#g' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf`  
   - `iptables -F`
   - `swapoff -a`
   - `free -m`
- Initialize cluster with kubeadm(I guess you can change address?)  
`kubeadm init --pod-network-cidr=10.217.0.0/16`  
- You will get instructions telling you that you can join a node to the cluster looking like this  
`kubeadm join 172.16.20.30:6443 --token uyc07q.423pybwurght29xw \
    --discovery-token-ca-cert-hash sha256:fc71f2e664df53f87b9ed2ca3980a86a1410bd882cd2208c6532da6b4baccf1c`    
- Because you are root you execute<sup>3</sup>  
`export KUBECONFIG=/etc/kubernetes/admin.conf`  
- "By default, your cluster will not schedule Pods on the control-plane node for security reasons." So we execute so pods can be schedules everywhere  
`kubectl taint nodes --all node-role.kubernetes.io/master-`  
- In order for the network to work we need to deploy a network add-on<sup>4</sup>(In this case Cilium)  
`kubectl create -f https://raw.githubusercontent.com/cilium/cilium/v1.6/install/kubernetes/quick-install.yaml`  
- **You can do final instruction of Worker part**
- **Move to Deployment**


## Worker

- On a new terminal connect to root  
`ssh root@<machine_name>`  
- Then run the already given docker setup with   
`sudo-g5k /grid5000/code/bin/g5k-setup-docker`  
- do these(don't know why):  
   - `systemctl stop docker`
   - `mv /var/lib/docker /tmp/docker`
   - `ln -s /tmp/docker/ /var/lib/docker`
   - `systemctl start docker`
- update sources  
`sudo apt-get update && sudo apt-get install -y apt-transport-https curl`  
- add key  
`curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -`  
- add source for kubernetes  
`echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list`  
- update, install and hold kubernetes  
   - `sudo apt-get update`
   - `sudo apt-get install -y kubelet kubeadm kubectl`
   - `sudo apt-mark hold kubelet kubeadm kubectl`
- preparatory config steps  
  - `kubeadm config images pull`  
  - `sed -i 's#Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=systemd"#Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=cgroupfs"#g' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf`  
  - `iptables -F`
  - `swapoff -a`
  - `free -m`
- **You can now execute the given join command!**

# Deployment of example image
- Now we should be able to see our nodes with  
`kubectl get nodes` or the cluster with 
`kubectl cluster-info `. They should be Ready
- You can label the node as a worker for fun  
`kubectl label node dahu-32.grenoble.grid5000.fr node-role.kubernetes.io/worker=worker`  
- Deploy a simple ngnix pod
`kubectl apply -f https://k8s.io/examples/application/deployment.yaml`
- Check the pods with
 `kubectl get pods`
- Getting detailed description on pods and deployment
 `kubectl describe pod <pod-name>`
 `kubectl describe deployment nginx-deployment`

# Deployment of Teastore and metrics server
- First the teastore can be deployed with:  
`kubectl create -f https://raw.githubusercontent.com/DescartesResearch/TeaStore/master/examples/kubernetes/teastore-clusterip.yaml`  
- ONLY after all pods are running, we can check if the connection to webui of the store is established. To get ip of node  
`kubectl get nodes -o wide`    
- Get the IP of the node where `teastore-webui` is running. Edit your ssh config file with the appropraite IP. Open a new terminal and type:  
`ssh teastore-web`   
For ssh configs see <sup>6</sup> .If not working, test with `wget -qO- <ip>:30080` at various stages.  
- For metrics server, we'll need to configure the yaml file, so I prefer to download it manually, as `kubectl edit` doesn't like me.  
`wget https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml`  
- Open with your favorite text editor <sup>7</sup>  
`nano components.yaml`
- go to the `kind: Deployment` part and under `spec:spec` write  
`hostNetwork: true`  
- just under the specs there will be `containers: -args`, you have to add 
`- --kubelet-insecure-tls`  
- Check if it work correctly by seeing the config file OR if we get metrics  
`kubectl get apiservice v1beta1.metrics.k8s.io -o yaml`  
`kubectl top pods <pod name>`  
- To get metrics via get do  
`kubectl get --raw /apis/metrics.k8s.io/v1beta1/nodes/<NODE_NAME> | jq`  or  
`kubectl get --raw /apis/metrics.k8s.io/v1beta1/namespaces/<NAMESPACE>/pods/<POD_NAME> | jq`  
- Or you could expose the api to your local machine <sup>9</sup> or maybe use a dashboard<sup>10</sup>

# Deletion
- To delete teastore  
`kubectl delete pods,deployments,services -l app=teastore`  
- To delete metrics server  
`kubectl delete -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml`  

# Appendix
- More on installation  
https://kubernetes.io/docs/tasks/tools/install-kubectl/  
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/  
- 1 - if not connected for some reason, you can use  
 `oarsub -C <job_id>`  
- 2 - machines names are listed by the command  
  `uniq $OAR_NODEFILE`  
- 3 - For non root type  
   - `mkdir -p $HOME/.kube`
   - `cp -i /etc/kubernetes/admin.conf $HOME/.kube/config`
   - `chown $(id -u):$(id -g) $HOME/.kube/config`
- 4 - Networking add-ons you can use  
https://kubernetes.io/docs/concepts/cluster-administration/addons/  
- 5 - Cheat sheet with kuberctl commands  
https://kubernetes.io/docs/reference/kubectl/cheatsheet/  
- 6 -
```
Host g5k
  User <username>
  HostName access.grid5000.fr
  ForwardAgent no

Host *.g5k
  User <username>
  ProxyCommand ssh g5k -W "$(basename %h .g5k):%p"
  ForwardAgent no

Host teastore-web
  User <username>
  HostName <node_ip_teastore>
  ProxyCommand ssh *.g5k -W %h:%p
  LocalForward 30080 localhost:30080

Host kubernetes-api
  User bbechev
  HostName <node_ip_kube_proxy>
  ProxyCommand ssh *.g5k -W %h:%p
  LocalForward 8080 localhost:8080
```  
- 7 - Don't forget yamls use spaces and not tabs  
- 8 - To see pods and services of metrics server, you need to add  
`-n kube-system` because of by default it sits in the kube-system namespace  
- 9 - We can start the api proxy server on 8080 just like the given ssh config
`kubectl proxy --port==8080` and on the localhost we can make api requests like  
`curl localhost:8080/apis/metrics.k8s.io/v1beta1/nodes/<NODE_NAME>`  
`curl localhost:8080/apis/metrics.k8s.io/v1beta1/namespaces/<NAMESPACE>/pods/<POD_NAME>`    
- 10 - In theory we can install dashboard via  
`kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml`  
then start the proxy `kubectl proxy --port==<port>`and create a new ssh connection in a new terminal to port forward but I couldn´t make it work
