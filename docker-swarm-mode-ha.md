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

### Persistency with host volume
### Persistency with remote volume
### Resource constraints: CPU, Memory, Disk 
### Failover

## HA Service 
### Persistency with host volume
### Persistency with distributed volume
### Resource constraints: CPU, Memory, Disk 
### Failover


## Reference
- Docker and swarm mode [part1](https://lostechies.com/gabrielschenker/2016/09/05/docker-and-swarm-mode-part-1/) [part2](https://lostechies.com/gabrielschenker/2016/09/11/docker-and-swarm-mode-part-2/) [part3](https://lostechies.com/gabrielschenker/2016/10/05/docker-and-swarm-mode-part-3/) [part4](https://lostechies.com/gabrielschenker/2016/10/22/docker-and-swarmkit-part-4/)
- [docker monitoring: cockpit](http://cockpit-project.org/)
