# SETUP Metrics collection on Grid 5000  

-  `ssh grenoble.g5k`  

-  reserve N nodes for T time `oarsub -I -l nodes=2,walltime=2 -t deploy`

-  `kadeploy3 -f $OAR_NODE_FILE -e debian10-x64-std -k`

-  open N frontends adn connect to machines `ssh root@<machine_name>`


# Master  

-  `git clone https://github.com/SCVFlare/TER-2021.git`

-  `chmod 777 -R TER-2021`

-  `cd TER-2021`

-  `master.sh`

-  do slave part

-  get node ip and name - `kubectl get nodes -o wide`

-  for N slaves `kubectl label nodes <slave_node> dedicated=slave`

-  `kubectl label nodes <master_node> dedicated=master`

-  `deployments.sh`

- Edit your local `./ssh/config`, make it look like `TER-2021/config` by adding your `<username>` as user and `<nodeip>` as hostname

- Open 5 terminals

- On first connect to master and `kubectl proxy --port=8080`

- On the 4 others

  -  `ssh teastore`

  -  `ssh kubernetes`

  -  `ssh prometheus`

  -  `ssh grafana`

# Slave  

-  `slave.sh`

- join cluster