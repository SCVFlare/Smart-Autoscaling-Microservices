import csv
import requests
import sys
import time

"""
A simple program to print the result of a Prometheus query as CSV.
"""
workload="twopeaks2all"
duration=7
interval=5.0
#raw_cpu_usage_web='http://localhost:30000/api/v1/query?query=sum(container_cpu_usage_seconds_total{pod="teastore-webui-5895447bdf-86k5j",container!="",container!="POD"})'
#raw_cpu_usage_total='http://localhost:30000/api/v1/query?query=sum(container_cpu_usage_seconds_total{dedicated="slave",container!="",container!="POD",pod=~"teastore.*"})'
#rate_cpu_usage_web='http://localhost:30000/api/v1/query?query=sum(rate(container_cpu_usage_seconds_total{pod="teastore-webui-5895447bdf-86k5j",container!="",container!="POD"}[60s]))'
#rate_cpu_usage_total='http://localhost:30000/api/v1/query?query=sum(rate(container_cpu_usage_seconds_total{dedicated="slave",container!="",container!="POD",pod=~"teastore.*"}[60s]))'
#total_percentage='http://localhost:30000/api/v1/query?query=sum(rate(container_cpu_usage_seconds_total{dedicated="slave",container!="",container!="POD",pod=~"teastore.*"}[60s]))/sum(machine_cpu_cores{dedicated="slave"})*100'
metrics_server_web='http://localhost:8080/apis/metrics.k8s.io/v1beta1/namespaces/default/pods/'
#metrics_server_slave='http://localhost:8080/apis/metrics.k8s.io/v1beta1/nodes/dahu-27.grenoble.grid5000.fr'
nb_replicas_web='http://localhost:30000/api/v1/query?query=kube_deployment_status_replicas'
#nb_replicas_web_available='http://localhost:30000/api/v1/query?query=kube_deployment_status_replicas_available{deployment="teastore-webui"}'
#nb_replicas_web_unavailable='http://localhost:30000/api/v1/query?query=kube_deployment_status_replicas_unavailable{deployment="teastore-webui"}'
query_names=["metrics_server_web","nb_replicas_web"]
#queries=[raw_cpu_usage_web,raw_cpu_usage_total,rate_cpu_usage_web,rate_cpu_usage_total,total_percentage,metrics_server_web,metrics_server_slave]
#starttime=time.time()
def query(i):
    collected=time.time()
    try:
        q1=requests.get(metrics_server_web).json()['items']
        q2=requests.get(nb_replicas_web).json()['data']['result']
        #q3=requests.get(nb_replicas_web_available).json()['data']['result'][0]['value']
        #q4=requests.get(nb_replicas_web_unavailable).json()['data']['result'][0]['value']
    except:
        return KeyError
    
    labelnames1 = ['name','collectedAt','timestamp','value']
    labelnames2 = ['name','collectedAt','timestamp','value']
    labelnames3 = ['collectedAt','timestamp','value']
    labelnames4 = ['collectedAt','timestamp','value']
    
    if(i==0):
        file_object  = open("metrics_server_web_"+workload+"_"+str(duration)+".csv", "w+") 
        file_object2  = open("nb_replicas_web_"+workload+"_"+str(duration)+".csv", "w+")
        #file_object3  = open("nb_replicas_web_available_"+workload+"_"+str(duration)+".csv", "a+")
        #file_object4  = open("nb_replicas_web_unavailable_"+workload+"_"+str(duration)+".csv", "a+")
        writer = csv.writer(file_object)
        writer2 = csv.writer(file_object2)
        #writer3 = csv.writer(file_object3)
        #writer4 = csv.writer(file_object4)
            # Write the header,
        writer.writerow(labelnames1)
        writer2.writerow(labelnames2)
        #writer3.writerow(labelnames3)
        #writer4.writerow(labelnames4)
            # Write the sanples.
        file_object.close()
        file_object2.close()
        #file_object3.close()
        #file_object4.close()
    file_object  = open("metrics_server_web_"+workload+"_"+str(duration)+".csv", "a+") 
    file_object2  = open("nb_replicas_web_"+workload+"_"+str(duration)+".csv", "a+")
    #file_object3  = open("nb_replicas_web_available_"+workload+"_"+str(duration)+".csv", "a+")
    #file_object4  = open("nb_replicas_web_unavailable_"+workload+"_"+str(duration)+".csv", "a+")
    writer = csv.writer(file_object)
    writer2 = csv.writer(file_object2)
    #writer3 = csv.writer(file_object3)
    #writer4 = csv.writer(file_object4)
    for i in q1:
        l=[i['metadata']['name'],collected,i['timestamp'],i['containers'][0]['usage']['cpu']]
        writer.writerow(l)
    for i in q2:
        l2=[i['metric']['deployment'],collected,i['value'][0],i['value'][1]]
        writer2.writerow(l2)
    #l2=[collected,q2[0],q2[1]]
    #l3=[collected,q3[0],q3[1]]
    #l4=[collected,q4[0],q4[1]]
    #writer.writerow(l)
    #writer2.writerow(l2)
    #writer3.writerow(l3)
    #writer4.writerow(l4)
    file_object.close()
    file_object2.close()
    #file_object3.close()
    #file_object4.close()

for i in range(144):
    start=time.time()
    print("#"+str(i)+"starting iteration"+str(time.ctime(start)))
    try:
        query(i)
    except KeyError:
        print("iteration FAILED")
    end=time.time()
    print("#"+str(i)+"finishing iteration"+str(time.ctime(end))+", DURATION:"+str(end-start))
    time.sleep(interval-(end-start))
