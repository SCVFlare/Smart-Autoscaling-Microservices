# SETUP Metrics collection on Grid 5000  

-  `oarsub -I -l nodes=2,walltime=2 -t deploy`

-  `kadeploy3 -f $OAR_NODE_FILE -e debian10-x64-std -k`

-  `ssh root@<machine_name>`

-  `git clone https://github.com/SCVFlare/TER-2021.git`

# Master  

-  `./TER-2021/master.sh`

- do slave part

- get node ip and name - `kubectl get nodes -o wide`

-  `kubectl label nodes <nodename> disktype=ssd`

-  `./TER-2021/deployments.sh`

- Edit your local `./ssh/config`, make it look like `TER-2021/config` by adding your `<username>` as user and `<nodeip>` as hostname

- Open 5 terminals

- On first connect to master and `kubectl proxy --port=8080`

- On the 4 others

  -  `ssh teastore`

  -  `ssh kubernetes`

  -  `ssh prometheus`

  -  `ssh grafana`

# Slave  

-  `./TER-2021/slave.sh`

- join cluster