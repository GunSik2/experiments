# Service HA in Docker Swarm Mode

## Single Service 
- Persistency : host volume, remote volume
- Resource : cpu, memory, disk
- Failover

### Environment
- nodes
```
$ for N in 1 2 3 4 5; do docker-machine create --driver virtualbox node$N; done
$ docker-machine ls
NAME    ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER    ERRORS
node1   -        virtualbox   Running   tcp://192.168.99.100:2376           v1.12.3
node2   -        virtualbox   Running   tcp://192.168.99.101:2376           v1.12.3
node3   -        virtualbox   Running   tcp://192.168.99.102:2376           v1.12.3
node4   -        virtualbox   Running   tcp://192.168.99.103:2376           v1.12.3
node5   -        virtualbox   Running   tcp://192.168.99.104:2376           v1.12.3
```
- docker-compose install in each node
```
docker pull docker/compose:1.8.1
echo "alias docker-compose='docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):/app --workdir /app docker/compose:1.8.1'" >> ~/.profile
docker-compose --version
```
- @node1 - swarm master
```
$ docker swarm init --advertise-addr 192.168.99.100
docker swarm join \
    --token SWMTKN-1-6b953d8fn3uqfs61syzdznzdd8cb3nd29fdc32idl7qhlp6pvp-dpfqsl43z09yi3jpke9c16cbh \
    192.168.99.100:2377
```
- @node[2-5] - swarm worker
```
docker swarm join \
    --token SWMTKN-1-6b953d8fn3uqfs61syzdznzdd8cb3nd29fdc32idl7qhlp6pvp-dpfqsl43z09yi3jpke9c16cbh \
    192.168.99.100:2377
```
- @node1 -promote two workers
```
$ docker node ls
ID                           HOSTNAME  STATUS  AVAILABILITY  MANAGER STATUS
2awy47v78vun8a7uno7ul6ghw    node3     Ready   Active
5r16jajagvw9t33yyqe3bowx6    node2     Ready   Active
av7czalmmixaqsv5bysodjkjv    node4     Ready   Active
dnip1a1yz18dl2axtr19sxx54 *  node1     Ready   Active        Leader
eloanuvl7m9zkggbjg086g7zq    node5     Ready   Active

$ docker node promote node2 node3
$ docker node ls
ID                           HOSTNAME  STATUS  AVAILABILITY  MANAGER STATUS
2awy47v78vun8a7uno7ul6ghw    node3     Ready   Active        Reachable
5r16jajagvw9t33yyqe3bowx6    node2     Ready   Active        Reachable
av7czalmmixaqsv5bysodjkjv    node4     Ready   Active
dnip1a1yz18dl2axtr19sxx54 *  node1     Ready   Active        Leader
eloanuvl7m9zkggbjg086g7zq    node5     Ready   Active
```
- @host - Master Failover Test 
```
$ docker-machine.exe stop node1
$ docker-machine.exe ssh node2 docker node ls
ID                           HOSTNAME  STATUS   AVAILABILITY  MANAGER STATUS
2awy47v78vun8a7uno7ul6ghw    node3     Ready    Active        Reachable
5r16jajagvw9t33yyqe3bowx6 *  node2     Ready    Active        Leader
av7czalmmixaqsv5bysodjkjv    node4     Ready    Active
dnip1a1yz18dl2axtr19sxx54    node1     Unknown  Active        Unreachable
eloanuvl7m9zkggbjg086g7zq    node5     Ready    Active

$ docker-machine.exe start node1
```
- @node1 - Run Private Registry
```
$ docker service create --name registry --publish 5000:5000 registry:2
$ curl localhost:5000/v2/_catalog

$ docker pull alpine
$ docker tag alpine localhost:5000/alpine
$ docker push localhost:5000/alpine
$ curl localhost:5000/v2/_catalog
{"repositories":["alpine"]}
```

### Persistency with host / remote volume
- volumen concept
  - A **bind-mount** makes a file or directory on the host available to the container it is mounted within. A bind-mount may be either read-only or read-write. For example, a container might share its host's DNS information by means of a bind-mount of the host's /etc/resolv.conf or a container might write logs to its host's /var/log/myContainerLogs directory. If you use bind-mounts and your host and containers have different notions of permissions, access controls, or other such details, you will run into portability issues.
  - A **named volume** is a mechanism for decoupling persistent data needed by your container from the image used to create the container and from the host machine. Named volumes are created and managed by Docker, and a named volume persists even when no container is currently using it. Data in named volumes can be shared between a container and the host machine, as well as between multiple containers. Docker uses a volume driver to create, manage, and mount volumes. You can back up or restore volumes using Docker commands.
  - A **tmpfs** mounts a tmpfs inside a container for volatile data.
- Supported types of bind-mounts and named volumes in a service : [docker service named volume support](https://github.com/docker/docker/blob/master/docs/reference/commandline/service_create.md#add-bind-mounts-or-volumes)
  - volume: mounts a managed volume into the container.
  - bind: bind-mounts a directory or file from the host into the container.
  - tmpfs: mount a tmpfs in the container

- docker using shared storage volume 
  - [Manage data in containers](https://docs.docker.com/engine/tutorials/dockervolumes/) 
  - [Volume plugins](https://docs.docker.com/engine/extend/legacy_plugins/)
```
$ docker volume create -d flocker -o size=20GB my-named-volume

$ docker run -d -P \
  -v my-named-volume:/webapp \
  --name web training/webapp python app.py
```
- docker service using bind mount(host volumne)
```
$ docker service create --help
Options:
      --mount value                    Attach a mount to the service
      
$ docker service create \
  --name my-service \
  --mount type=bind,source=/path/on/host,destination=/path/in/container \
  nginx:alpine
```
- docker service using named volume(host/remote volume) 
```
```
  
### Resource constraints: CPU, Memory, Disk 
- CPU & Memory : Use [docker service create options](https://docs.docker.com/engine/reference/commandline/service_create/)
```
$ docker service create --help
Options:
      --limit-cpu value                Limit CPUs (default 0.000)
      --limit-memory value             Limit Memory (default 0 B)
      --reserve-cpu value              Reserve CPUs (default 0.000)
      --reserve-memory value           Reserve Memory (default 0 B)
```
### Resource constraint: Disk
- [dockerd storage driver option](https://docs.docker.com/engine/reference/commandline/dockerd/#/daemon-storage-driver-option)
  - boot2linux doesn't support to change auft to devicemapper
```
$ cat /var/lib/boot2docker/profile
DOCKER_STORAGE=aufs  #devicemapper
$ /etc/init.d/docker restart   # dockerd --storage-driver=devicemapper 
```
- [docker run option](https://docs.docker.com/engine/reference/commandline/run/#/set-storage-driver-options-per-container) available for devicemapper, btrfs, and zfs drivers. 
  - Recommended storage driver in CS Engine compatibility matrix : [performance comparison](https://docs.docker.com/engine/userguide/storagedriver/images/driver-pros-cons.png)
    - vRHEL 7.0, 7.1, 7.2: devicemapper
    - Ubuntu: aufs3
    - CentOS 7.1-1503, 7.2-1511: devicemapper
    - SLES: btrfs
```
$ docker info | grep Driver
Storage Driver: aufs

$ docker run -it --storage-opt size=120G fedora /bin/bash
```
### Failover
### Service routing  
### Authentication & Authorization

## HA Service 
### Persistency with host volume
### Persistency with distributed volume
### Resource constraints: CPU, Memory, Disk 
### Failover
### Service routing 
### Authentication & Authorization


## Reference
- Docker and swarm mode [part1](https://lostechies.com/gabrielschenker/2016/09/05/docker-and-swarm-mode-part-1/) [part2](https://lostechies.com/gabrielschenker/2016/09/11/docker-and-swarm-mode-part-2/) [part3](https://lostechies.com/gabrielschenker/2016/10/05/docker-and-swarm-mode-part-3/) [part4](https://lostechies.com/gabrielschenker/2016/10/22/docker-and-swarmkit-part-4/)
- [Docker Flow Proxy](https://github.com/vfarcic/docker-flow-proxy) [article1](https://technologyconversations.com/2016/08/01/integrating-proxy-with-docker-swarm-tour-around-docker-1-12-series/)
- [Docker 1.12 Networking Model](http://collabnix.com/archives/1391)
- [docker monitoring: cockpit](http://cockpit-project.org/)
- [docker storage driver](https://docs.docker.com/engine/userguide/storagedriver/selectadriver/)
