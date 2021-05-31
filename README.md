# SETUP Metrics collection on Grid 5000  

-  `ssh grenoble.g5k`  

-  reserve N nodes for T time `oarsub -I -l nodes=2,walltime=2 -t deploy`

-  `kadeploy3 -f $OAR_NODE_FILE -e debian10-x64-std -k`

-  open N frontends adn connect to machines `ssh root@<machine_name>`


# Master  

-  `git clone https://github.com/SCVFlare/TER-2021.git`

-  `chmod 777 -R TER-2021`

-  `cd TER-2021`

-  `./master.sh`

-  WAIT for all to be running and do slave part

-  get node ip and name - `kubectl get nodes -o wide`

-  for N slaves `kubectl label nodes <slave_node> dedicated=slave`

-  `kubectl label nodes <master_node> dedicated=master`

-  `./deployments.sh`

- Edit your local `./ssh/config`, make it look like `TER-2021/config` by adding your `<username>` as user and `<nodeip>` as hostname

- Open 5 terminals

- On first connect to master and `kubectl proxy --port=8080`

- On the 4 others

  -  `ssh teastore`

  -  `ssh kubernetes`

  -  `ssh prometheus`

  -  `ssh grafana`

- `kubectl autoscale deployment <teastore-deployment> --cpu-percent=50 --min=1 --max=10`

- Check if all ok `kubectl get hpa`

- You can load a particular microsevice(webui for example):
  - `kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- https://<node_ip>:30080/tools.descartes.teastore.webui/; done"`  

- OR use loadgenerator:
  - `java -jar httploadgenerator.jar loadgenerator` - call the generator
  - `$ java -jar httploadgenerator.jar director --ip <nodeIP> --load <arrivalrate.csv> -o <results.csv> --lua <script.lua>` - call the director, you could put both on the master machine  

- Use Limbo in eclipse to genrate loads

- use pytohn script to take out all neccesseary metrics

- treat results with colab script

# Slave  

-  `git clone https://github.com/SCVFlare/TER-2021.git`

-  `chmod 777 -R TER-2021`

-  `cd TER-2021`

-  `./slave.sh`

- join cluster
