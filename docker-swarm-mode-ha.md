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
- [Docker and swarm mode](https://lostechies.com/gabrielschenker/2016/09/05/docker-and-swarm-mode-part-1/)
- [docker monitoring: cockpit](http://cockpit-project.org/)
