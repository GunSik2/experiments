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

#### Provisioning Instances with docker-machine
- Install docker-machine
```
curl -L https://github.com/docker/machine/releases/download/v0.8.2/docker-machine-`uname -s`-`uname -m` >/usr/local/bin/docker-machine && \
chmod +x /usr/local/bin/docker-machine
docker-machine version
```

- Provision nodes
```
vi paas.rc
OS_AUTH_URL
OS_TENANT_ID
OS_TENANT_NAME
OS_USERNAME
OS_PASSWORD

vi dmachine.env
export OS_IMAGE_ID=5edf9486-e3b0-445e-a1d2-525313e1bdc1   #nova image-list
export OS_FLAVOR_ID=3                                     #nova flavor-list
export OS_NETWORK_ID=51d1d3b5-d972-453f-88a6-6ebe38fe4dbf #nova net-list   
export OS_SSH_USER=ubuntu
export OS_SECURITY_GROUPS=docker
export OS_SECURITY_GROUPS=swarm

. paas.rc
. dmachine.env
docker-machine create -d openstack swarm-1
docker-machine create -d openstack swarm-2
docker-machine create -d openstack swarm-3
docker-machine ls

$ eval $(docker-machine env swarm-1)
```
- Trouble-shooting: network name server setting
```
$ neutron subnet-update d46407a9-fd76-441c-bc55-cf44c6bca257 --dns-nameservers list=true 8.8.8.8
$ neutron subnet-show d46407a9-fd76-441c-bc55-cf44c6bca257
```

#### Provisioning Instances with nova cli
- Create nodes
- Install Docker Engine on each Server
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

### HA Installation: five nodes 
#### Topology 
- three seperate managers with three etcd   
- two worker nodes 

#### Consideration
- master should be provisioned in separated zones
- consul/etcd should be provisoned in at least 3 nodes
- persistent volume, such as ceph should be provisioned.
- master node & worker node seperation for stable master node service: master node no more services worker in itself.

#### master nodes deployment
- install etcd cluster on three master nodes: refer to the following chapter
- install swarm master/slave in swarm nodes
```
# master manager server
docker run -d -p <manager1 IP>:4000:4000 --name swarm swarm manage -H :4000 --replication --advertise <manager1 IP>:4000 etcd://<etcd_addr1>:2379,<etcd_addr2>:2379,<etcd_addr3>:2379
# slave manager server
docker run -d -p <manager2 IP>:4000:4000 --name swarm swarm manage -H :4000 --replication --advertise <manager2 IP>:4000 etcd://<etcd_addr1>:2379,<etcd_addr2>:2379,<etcd_addr3>:2379
docker run -d -p <manager3 IP>:4000:4000 --name swarm swarm manage -H :4000 --replication --advertise <manager3 IP>:4000 etcd://<etcd_addr1>:2379,<etcd_addr2>:2379,<etcd_addr3>:2379
```

#### Add two worker nodes
- join worker node
```
docker run -d swarm join --advertise=<node IP>:2375 consul://<consul IP>:8500
```
- check swarm state
```
docker -H 10.101.0.22:4000 info
```

#### trouble shooting
- Cannot connect to the Docker daemon. Is the docker daemon running on this host


#### etcd cluster on three master nodes 
- Install
```
vi etcd_cluster.sh
ETCD_VERSION=v3.0.0
TOKEN=etcd-token
CLUSTER_STATE=new
NAME_1="etcd-0"
NAME_2="etcd-1"
NAME_3="etcd-2"
HOST_1=10.101.0.22
HOST_2=10.101.0.21
HOST_3=10.101.0.23
CLUSTER=${NAME_1}=http://${HOST_1}:2380,${NAME_2}=http://${HOST_2}:2380,${NAME_3}=http://${HOST_3}:2380
LISTEN_IP=0.0.0.0

# For node 1
function etcd1() {
  THIS_NAME=${NAME_1}
  THIS_IP=${HOST_1}
  sudo docker run -d -p 2379:2379 -p 2380:2380 --name etcd quay.io/coreos/etcd:${ETCD_VERSION} \
      /usr/local/bin/etcd \
      --data-dir=data.etcd --name ${THIS_NAME} \
      --initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://${LISTEN_IP}:2380 \
      --advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://${LISTEN_IP}:2379 \
      --initial-cluster ${CLUSTER} \
      --initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}
}

# For node 2
function etcd2() {
  THIS_NAME=${NAME_2}
  THIS_IP=${HOST_2}
  sudo docker run -d -p 2379:2379 -p 2380:2380 --name etcd quay.io/coreos/etcd:${ETCD_VERSION} \
      /usr/local/bin/etcd \
      --data-dir=data.etcd --name ${THIS_NAME} \
      --initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://${LISTEN_IP}:2380 \
      --advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://${LISTEN_IP}:2379 \
      --initial-cluster ${CLUSTER} \
      --initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}
}

# For node 3
function etcd3() {
  THIS_NAME=${NAME_3}
  THIS_IP=${HOST_3}
  sudo docker run -d -p 2379:2379 -p 2380:2380 --name etcd quay.io/coreos/etcd:${ETCD_VERSION} \
      /usr/local/bin/etcd \
      --data-dir=data.etcd --name ${THIS_NAME} \
      --initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://${LISTEN_IP}:2380 \
      --advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://${LISTEN_IP}:2379 \
      --initial-cluster ${CLUSTER} \
      --initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}
}
$*


docker-machine ssh swarm-1 "bash -s" < bin/etcd_cluster.sh etcd1
docker-machine ssh swarm-2 "bash -s" < bin/etcd_cluster.sh etcd2
docker-machine ssh swarm-3 "bash -s" < bin/etcd_cluster.sh etcd3
```
- Probe
```
curl -L 10.101.0.22:2379/version    
curl -L 10.101.0.22:2379/v2/stats/leader | jq
{
  "leader": "398c17227fb5a79d",
  "followers": {
    "2528e52980223be9": {
      "latency": {
        "current": 0.002113,
        "average": 0.006612783783783781,
        "standardDeviation": 0.04308765319156819,
        "minimum": 0.000929,
        "maximum": 0.642134
      },
      "counts": {
        "fail": 39,
        "success": 222
      }
    },
    "643b458c9c66ac8c": {
      "latency": {
        "current": 0.00197,
        "average": 0.004077473972602739,
        "standardDeviation": 0.006005751956387417,
        "minimum": 0.00097,
        "maximum": 0.104687
      },
      "counts": {
        "fail": 0,
        "success": 365
      }
    }
  }
}
```
- action : CRUD
```
curl 10.101.0.22:2379/v2/keys/message -XPUT -d value="Hello world"
curl 10.101.0.22:2379/v2/keys/message
curl 10.101.0.22:2379/v2/keys/message -XPUT -d value="Hello etcd"
curl 10.101.0.22:2379/v2/keys/message
curl 10.101.0.22:2379/v2/keys/message -XDELETE

curl 10.101.0.22:2379/v2/keys/swarm?recursive=true -XDELETE
curl 10.101.0.22:2379/v2/keys/swarm?recursive=true | jq
```
- Failover Test
```
docker-machine ssh swarm-3 "sudo docker stop etcd; sudo docker rm etcd"
curl -L 10.101.0.22:2379/v2/stats/leader | jq
docker-machine ssh swarm-3 "bash -s" < bin/etcd_cluster.sh etcd3
curl -L 10.101.0.22:2379/v2/stats/leader | jq

docker-machine ssh swarm-1 "sudo docker stop etcd; sudo docker rm etcd"
curl -L 10.101.0.21:2379/v2/stats/leader | jq
docker-machine ssh swarm-1 "bash -s" < bin/etcd_cluster.sh etcd1
curl -L 10.101.0.21:2379/v2/stats/leader | jq
```
- Failover trobuleshooting : etcdmain: member 2528e52980223be9 has already been bootstrapped 
    - If you lost the data dir of a member, you cannot restart a member that was in the cluster. 
    - If you lost your data dir, you have to remove that member via dynamic configuration API start etcd with previous configuration.
```
remove the old member via dynamic configuration API
add the new member via dynamic configuration API
remove all residuals datas : `rm -rf /var/lib/etcd2/*`
start etcd with initial-cluster=existing
```   
- Further action for production
  - etcd tls configuration
  - etcd data store to use host volume or ceph
```
function etcd1() {
  THIS_NAME=${NAME_1}
  THIS_IP=${HOST_1}
  sudo mkdir /var/local/etcd
  sudo docker run -d -p 2379:2379 -p 2380:2380 -v /var/local/etcd:/data --name etcd quay.io/coreos/etcd:${ETCD_VERSION} \
      /usr/local/bin/etcd \
      --data-dir=/data --name ${THIS_NAME} \
      --initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://${LISTEN_IP}:2380 \
      --advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://${LISTEN_IP}:2379 \
      --initial-cluster ${CLUSTER} \
      --initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}
}

curl http://10.101.0.22:2379/v2/keys/message -XPUT -d value="Hello world"
curl http://10.101.0.22:2379/v2/keys/message
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
- [Swarm Openstak : How to Swarm on OpenStack](https://j-griffith.github.io/articles/2016-09/how-to-swarm-on-openstack)
- [Swarm Cluster : How to Configure Docker Swarm](https://www.upcloud.com/support/how-to-configure-docker-swarm/)
- [Swarm Cluster : High availability in Docker Swarm](https://docs.docker.com/swarm/multi-manager-setup/)
- [Swarm Cluster : Plan for Swarm in production](https://docs.docker.com/swarm/plan-for-production/)
- [Swarm Cluster : Docker Swarm discovery](https://docs.docker.com/swarm/discovery/)
- [Swarm Cluster : Docker comes with multiple Discovery backends](https://github.com/docker/docker/tree/master/pkg/discovery)
- [Swarm - MySQL : MySQL on Docker](http://severalnines.com/blog/mysql-docker-introduction-docker-swarm-mode-and-multi-host-networking)
- [CDocker - CEPH : GETTING STARTED WITH THE DOCKER RBD VOLUME PLUGIN](http://ceph.com/planet/getting-started-with-the-docker-rbd-volume-plugin/)
- [Docker - CEPH : Contiv volplugin](https://github.com/contiv/volplugin)
- [Docker etcd cluster : Run etcd clusters inside containers](https://github.com/coreos/etcd/blob/master/Documentation/op-guide/container.md)
- [etcd api](https://coreos.com/etcd/docs/latest/api.html)
- [swarm join virtualbox case](https://github.com/docker/swarm/issues/2341)
### Appendix
- Docker-machine options
```
$ docker-machine -h
Usage: docker-machine [OPTIONS] COMMAND [arg...]

Create and manage machines running Docker.

Version: 0.8.2, build e18a919

Author:
  Docker Machine Contributors - <https://github.com/docker/machine>

Options:
  --debug, -D                                                   Enable debug mode
  --storage-path, -s "/home/external/stg/.docker/machine"       Configures storage path [$MACHINE_STORAGE_PATH]
  --tls-ca-cert                                                 CA to verify remotes against [$MACHINE_TLS_CA_CERT]
  --tls-ca-key                                                  Private key to generate certificates [$MACHINE_TLS_CA_KEY]
  --tls-client-cert                                             Client cert to use for TLS [$MACHINE_TLS_CLIENT_CERT]
  --tls-client-key                                              Private key used in client TLS auth [$MACHINE_TLS_CLIENT_KEY]
  --github-api-token                                            Token to use for requests to the Github API [$MACHINE_GITHUB_API_TOKEN]
  --native-ssh                                                  Use the native (Go-based) SSH implementation. [$MACHINE_NATIVE_SSH]
  --bugsnag-api-token                                           BugSnag API token for crash reporting [$MACHINE_BUGSNAG_API_TOKEN]
  --help, -h                                                    show help
  --version, -v                                                 print the version

Commands:
  active                Print which machine is active
  config                Print the connection config for machine
  create                Create a machine
  env                   Display the commands to set up the environment for the Docker client
  inspect               Inspect information about a machine
  ip                    Get the IP address of a machine
  kill                  Kill a machine
  ls                    List machines
  provision             Re-provision existing machines
  regenerate-certs      Regenerate TLS Certificates for a machine
  restart               Restart a machine
  rm                    Remove a machine
  ssh                   Log into or run a command on a machine with SSH.
  scp                   Copy files between machines
  start                 Start a machine
  status                Get the status of a machine
  stop                  Stop a machine
  upgrade               Upgrade a machine to the latest version of Docker
  url                   Get the URL of a machine
  version               Show the Docker Machine version or a machine docker version
  help                  Shows a list of commands or help for one command


$ docker-machine create -d openstack -h
Usage: docker-machine create [OPTIONS] [arg...]

Create a machine

Description:
   Run 'docker-machine create --driver name' to include the create flags for that driver in the help text.

Options:

   --driver, -d "none"                                                                                  Driver to create machine with. [$MACHINE_DRIVER]
   --engine-env [--engine-env option --engine-env option]                                               Specify environment variables to set in the engine
   --engine-insecure-registry [--engine-insecure-registry option --engine-insecure-registry option]     Specify insecure registries to allow with the created engine
   --engine-install-url "https://get.docker.com"                                                        Custom URL to use for engine installation [$MACHINE_DOCKER_INSTALL_URL]
   --engine-label [--engine-label option --engine-label option]                                         Specify labels for the created engine
   --engine-opt [--engine-opt option --engine-opt option]                                               Specify arbitrary flags to include with the created engine in the form flag=value
   --engine-registry-mirror [--engine-registry-mirror option --engine-registry-mirror option]           Specify registry mirrors to use [$ENGINE_REGISTRY_MIRROR]
   --engine-storage-driver                                                                              Specify a storage driver to use with the engine
   --openstack-active-timeout "200"                                                                     OpenStack active timeout [$OS_ACTIVE_TIMEOUT]
   --openstack-auth-url                                                                                 OpenStack authentication URL [$OS_AUTH_URL]
   --openstack-availability-zone                                                                        OpenStack availability zone [$OS_AVAILABILITY_ZONE]
   --openstack-domain-id                                                                                OpenStack domain ID (identity v3 only) [$OS_DOMAIN_ID]
   --openstack-domain-name                                                                              OpenStack domain name (identity v3 only) [$OS_DOMAIN_NAME]
   --openstack-endpoint-type                                                                            OpenStack endpoint type (adminURL, internalURL or publicURL) [$OS_ENDPOINT_TYPE]
   --openstack-flavor-id                                                                                OpenStack flavor id to use for the instance [$OS_FLAVOR_ID]
   --openstack-flavor-name                                                                              OpenStack flavor name to use for the instance [$OS_FLAVOR_NAME]
   --openstack-floatingip-pool                                                                          OpenStack floating IP pool to get an IP from to assign to the instance [$OS_FLOATINGIP_POOL]
   --openstack-image-id                                                                                 OpenStack image id to use for the instance [$OS_IMAGE_ID]
   --openstack-image-name                                                                               OpenStack image name to use for the instance [$OS_IMAGE_NAME]
   --openstack-insecure                                                                                 Disable TLS credential checking. [$OS_INSECURE]
   --openstack-ip-version "4"                                                                           OpenStack version of IP address assigned for the machine [$OS_IP_VERSION]
   --openstack-keypair-name                                                                             OpenStack keypair to use to SSH to the instance [$OS_KEYPAIR_NAME]
   --openstack-net-id                                                                                   OpenStack network id the machine will be connected on [$OS_NETWORK_ID]
   --openstack-net-name                                                                                 OpenStack network name the machine will be connected on [$OS_NETWORK_NAME]
   --openstack-nova-network                                                                             Use the nova networking services instead of neutron. [$OS_NOVA_NETWORK]
   --openstack-password                                                                                 OpenStack password [$OS_PASSWORD]
   --openstack-private-key-file                                                                         Private keyfile to use for SSH (absolute path) [$OS_PRIVATE_KEY_FILE]
   --openstack-region                                                                                   OpenStack region name [$OS_REGION_NAME]
   --openstack-sec-groups                                                                               OpenStack comma separated security groups for the machine [$OS_SECURITY_GROUPS]
   --openstack-ssh-port "22"                                                                            OpenStack SSH port [$OS_SSH_PORT]
   --openstack-ssh-user "root"                                                                          OpenStack SSH user [$OS_SSH_USER]
   --openstack-tenant-id                                                                                OpenStack tenant id [$OS_TENANT_ID]
   --openstack-tenant-name                                                                              OpenStack tenant name [$OS_TENANT_NAME]
   --openstack-user-data-file                                                                           File containing an openstack userdata script [$OS_USER_DATA_FILE]
   --openstack-username                                                                                 OpenStack username [$OS_USERNAME]
   --swarm                                                                                              Configure Machine to join a Swarm cluster
   --swarm-addr                                                                                         addr to advertise for Swarm (default: detect and use the machine IP)
   --swarm-discovery                                                                                    Discovery service to use with Swarm
   --swarm-experimental                                                                                 Enable Swarm experimental features
   --swarm-host "tcp://0.0.0.0:3376"                                                                    ip/socket to listen on for Swarm master
   --swarm-image "swarm:latest"                                                                         Specify Docker image to use for Swarm [$MACHINE_SWARM_IMAGE]
   --swarm-join-opt [--swarm-join-opt option --swarm-join-opt option]                                   Define arbitrary flags for Swarm join
   --swarm-master                                                                                       Configure Machine to be a Swarm master
   --swarm-opt [--swarm-opt option --swarm-opt option]                                                  Define arbitrary flags for Swarm master
   --swarm-strategy "spread"                                                                            Define a default scheduling strategy for Swarm
   --tls-san [--tls-san option --tls-san option]                                                        Support extra SANs for TLS certs

```
