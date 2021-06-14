sudo-g5k /grid5000/code/bin/g5k-setup-docker #install docker
systemctl stop docker
mv /var/lib/docker /tmp/docker
ln -s /tmp/docker/ /var/lib/docker
systemctl start docker
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl #install kubernetes components
sudo apt-mark hold kubelet kubeadm kubectl
kubeadm config images pull #kubeadm creates the cluster
#The below command sets the config files for the cluster. THis could potentially be modified if you need to use different kubelet settings
#https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/
sed -i 's#Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=systemd"#Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=cgroupfs"#g' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
iptables -F
swapoff -a
free -m
kubeadm init --pod-network-cidr=10.217.0.0/16
#To have privelleges to execute kubectl. This could be put on other nodes so the have rights as well(I think)
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
kubectl taint nodes --all node-role.kubernetes.io/master- #makes it so you can deploy yamls on the master node as well
#you can use other network policy providers than other than cillium
#https://kubernetes.io/docs/tasks/administer-cluster/network-policy-provider/
kubectl create -f https://raw.githubusercontent.com/cilium/cilium/v1.6/install/kubernetes/quick-install.yaml # 

