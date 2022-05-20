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
apt update
apt install git wget curl
VER=$(curl -s https://api.github.com/repos/Mirantis/cri-dockerd/releases/latest|grep tag_name | cut -d '"' -f 4)
wget https://github.com/Mirantis/cri-dockerd/releases/download/${VER}/cri-dockerd-${VER}-linux-amd64.tar.gz
tar xvf cri-dockerd-${VER}-linux-amd64.tar.gz
### Move cri-dockerd binary package to /usr/local/bin directory
sudo mv cri-dockerd /usr/local/bin/
### Configure systemd units for cri-dockerd
wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.service
wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.socket
mv cri-docker.socket cri-docker.service /etc/systemd/system/
sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
### Start and enable the services
systemctl daemon-reload
systemctl enable cri-docker.service
systemctl enable --now cri-docker.socket
kubeadm config images pull --cri-socket /run/cri-dockerd.sock 
#The below command sets the config files for the cluster. THis could potentially be modified if you need to use different kubelet settings
#https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/
iptables -F
swapoff -a
free -m
