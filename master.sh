sudo-g5k /grid5000/code/bin/g5k-setup-docker
systemctl stop docker
mv /var/lib/docker /tmp/docker
ln -s /tmp/docker/ /var/lib/docker
systemctl start docker
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
kubeadm config images pull
sed -i 's#Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=systemd"#Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=cgroupfs"#g' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
iptables -F
swapoff -a
free -m
kubeadm init --pod-network-cidr=10.217.0.0/16
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
kubectl taint nodes --all node-role.kubernetes.io/master-
