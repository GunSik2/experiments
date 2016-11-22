# Docker Swarm Cluster in OpenStack

## Docker Swarm 
- With the latest Docker 1.12 release, a “swarm mode” has been introduced as a native part of the Docker Engine
- Swarm mode uses the manager/worker-model
  - A manager node distributes tasks across worker nodes, where the worker node executes the tasks assigned to it.
  - A primary manager is the main point of contact with the Docker Swarm cluster.
  - Requests issued on a replica are automatically proxied to the primary manager.
  - If the primary manager fails, a replica takes away the lead.
- Swarm mode requires an odd number of backend discovery service nodes to maintain quorum for fault tolerance. 
- By default, manager nodes are also worker nodes.  

### Topology
![Swarm cluster configured for HA](http://farm2.staticflickr.com/1675/24380252320_999687d2bb_b.jpg)
![Swarm cluster concept](https://www.upcloud.com/support/wp-content/uploads/2016/03/Docker-Swarm.png)

### Installation: three nodes
#### Topology
- three managers with single consul 

#### Install Docker Engine on each Server
```
sudo apt-get install curl -y
curl -sSL https://get.docker.com/ | sh
sudo service docker stop
sudo nohup docker daemon -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock &
sudo docker info
sudo usermod -aG docker <username>
```
#### Configure backend discovery services
- The consul/etcd/zookeeper service maintains a list of IP addresses in your Swarm cluster. 
```
docker run -d -p 8500:8500 --name=consul progrium/consul -server -bootstrap
```
#### Create a Swarm Cluster
- primary manager server
```
docker run -d -p <manager1 IP>:4000:4000 swarm manage -H :4000 --replication --advertise <manager1 IP>:4000 consul://<consul IP>:8500
```
- two replicas
```
docker run -d -p <manager2 IP>:4000:4000 swarm manage -H :4000 --replication --advertise <manager2 IP>:4000 consul://<consul IP>:8500
docker run -d -p <manager3 IP>:4000:4000 swarm manage -H :4000 --replication --advertise <manager2 IP>:4000 consul://<consul IP>:8500
```

#### Running the Swarm
- check the primary master configuration
```
docker -H <manager1 IP>:4000 info
```
- start containers 
```
docker -H <manager1 IP>:4000 run hello-world
docker -H <manager1 IP>:4000 ps -a

```
#### Test Swarm master fail-over
- Check the cluster info of primary and secondary 
```
docker -H <manager1 IP>:4000 info
docker -H <manager2 IP>:4000 info
```
- Stop primary
```
docker stop <swarm manager name>
```
- Check secondary info :  The replica manager will take the lead in becoming the new primary.
```
docker -H <manager2 IP>:4000 info
```
- Start primary : It become the new replica.
```
docker start <swarm manager name>
docker -H <manager1 IP>:4000 info
```

### Installation: five nodes
#### Topology 
- three seperate managers with three consul  
- two worker nodes 

#### each worker node

#### each worker node
```
docker run -d swarm join --advertise=<node IP>:2375 consul://<consul IP>:8500
```


## volplugin
### Components
- apiserver :  API service taht give volcli a way to coordinate with the cluster at large. Store state with etcd
- volsupervisor :   service handles scheduled and supervised tasks such as snapshotting
- volplugin : plugin process that manages the lifecycle of volume mounts on every host that runs containers
- volcli : utility that manages the apiserver's data
- etcd
- ceph

### Topology
```
                  (Docker)
----- volcli      volplugin ---------  
|        |          |               |
|        V          V               |
|      apiserver (0.0.0.0:9005)     |
|          |                        |  
|          V                        |
------>  etcd (127.0.0.1:2379) <-----
```

## Reference
- [Swarm Cluster : How to Configure Docker Swarm](https://www.upcloud.com/support/how-to-configure-docker-swarm/)
- [Swarm Cluster : High availability in Docker Swarm](https://docs.docker.com/swarm/multi-manager-setup/)
- [Swarm Cluster : Plan for Swarm in production](https://docs.docker.com/swarm/plan-for-production/)
- [Swarm - MySQL : MySQL on Docker](http://severalnines.com/blog/mysql-docker-introduction-docker-swarm-mode-and-multi-host-networking)
- [CDocker - CEPH : GETTING STARTED WITH THE DOCKER RBD VOLUME PLUGIN](http://ceph.com/planet/getting-started-with-the-docker-rbd-volume-plugin/)
- [Docker - CEPH : Contiv volplugin](https://github.com/contiv/volplugin)
