# SETUP Metrics collection on Grid 5000  

-  `ssh grenoble.g5k`  

-  reserve N nodes for some time `oarsub -I -l nodes=2,walltime=2 -t deploy`

-  `kadeploy3 -f $OAR_NODE_FILE -e debian10-x64-std -k`

-  open N frontends and connect to machines `ssh root@<machine_name>`


# Master  

-  `git clone https://github.com/SCVFlare/TER-2021.git`

-  `chmod 777 -R TER-2021`

-  `cd TER-2021`

-  `./master.sh`. Comments in the file

-  WAIT for all pods `kubectl get pods -n kube-system` to be running and do slave section. A command will appear giving you the command to cennect other nodes to the cluster

-  get node ip and name - `kubectl get nodes -o wide`

-  for N slaves `kubectl label nodes <slave_node> dedicated=slave`

-  `kubectl label nodes <master_node> dedicated=master`

-  All yamls have been modified with label `nodeSelector` to direct where to deploy pod- either on master or slave. I put teastore on worker and everything else on master node. Ports can be changed

-  `./deployments.sh`. For each deployemnt you can read md doc.

- Edit your local `./ssh/config`, make it look like `TER-2021/config` by adding your `<username>` as user and `<nodeip>` as hostname. 

- Open 5 terminals

- On first connect to master and `kubectl proxy --port=8080` to expose the api to ypur localhost

- On the 4 others

  -  `ssh teastore`

  -  `ssh kubernetes`

  -  `ssh prometheus`

  -  `ssh grafana`

- TO UPDATE yaml files I just delete deployment, change the yaml and re-apply yaml. 
# Slave  

-  `git clone https://github.com/SCVFlare/TER-2021.git`

-  `chmod 777 -R TER-2021`

-  `cd TER-2021`

-  `./slave.sh`

- join cluster via commend given on master node

# MOVE ON TO Scaling.md
MOVE ON TO Scaling.md