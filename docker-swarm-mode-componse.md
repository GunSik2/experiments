## Key term
- Container orchestration - self-healing, rolling or parallel update
- [Linux IPVS](http://www.linuxvirtualserver.org/software/ipvs.html)(IP Virtual Server)  
- [Distributed Application Bundle & Stacks](https://github.com/docker/docker/blob/master/experimental/docker-stacks-and-bundles.md)
- [gRPC](http://www.grpc.io/) - internode communication for HTTP/2 benefits like connection multiplexing and header compression
- [protobufs](https://developers.google.com/protocol-buffers/)

## Swarm App
- Two tier app
```
docker network create -d overlay mynet
docker service create –name frontend –replicas 5 -p 80:80/tcp –network mynet nginx:latest
docker service create –name redis –network mynet redis:latest
docker service scale frontend=10
```

## Swarm mode & Compose
- Docker Compose with swarm mode is not supported for now. 
- [converter "docker-compose.yml" file to "docker service commands"](https://github.com/ddrozdov/docker-compose-swarm-mode)
```
pip install docker-compose-swarm-mode
```

## Distributed Application Bundle(DAB) & Stacks
- Concept
  - A **Dockerfile** can be built into an **image**, and **containers** can be created from that image
  - Similarly, a **docker-compose.yml** can be built into a **distributed application bundle**, and **stacks** can be created from that bundle.
  - The bundle is a multi-services distributable image format
  - Experiment feature in Docker 1.12 and Compose 1.8
- Install experimental feature
```
$ curl -sSL https://experimental.docker.com/ | sh
```
- Createing bundle
```
$ docker-compose bundle
Wrote bundle to vossibility-stack.dab
```
- Creating a stack from a bundle
```
$ docker deploy vossibility-stack
$ docker service ls
```
- Managing stacks
```
$ docker stack --help
```
## Reference
- [docker 1.12 built in orchestration](https://blog.docker.com/2016/06/docker-1-12-built-in-orchestration/)
- [application bundle](https://github.com/docker/docker/blob/master/experimental/docker-stacks-and-bundles.md)
- [docker experimental features](https://github.com/docker/docker/tree/master/experimental)
