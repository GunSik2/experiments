

- manager01
```
$ docker swarm init --advertise-addr 10.101.0.22
Swarm initialized: current node (9xobningonsptorguyv5bukfm) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-0d4c62gn0r2vx470q0tr0zcvjfvd0kd0t0zwd7okb6xjj9bm6w-1vapc6cnf1kwv0dfnt162km2t \
    10.101.0.22:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

$ docker info

$ docker swarm join-token worker
    docker swarm join \
    --token SWMTKN-1-0d4c62gn0r2vx470q0tr0zcvjfvd0kd0t0zwd7okb6xjj9bm6w-1vapc6cnf1kwv0dfnt162km2t \
    10.101.0.22:2377
```
- worker1
```
$ docker swarm join \
    --token SWMTKN-1-0d4c62gn0r2vx470q0tr0zcvjfvd0kd0t0zwd7okb6xjj9bm6w-1vapc6cnf1kwv0dfnt162km2t \
    10.101.0.22:2377
```
- worker2
```
$ docker swarm join \
    --token SWMTKN-1-0d4c62gn0r2vx470q0tr0zcvjfvd0kd0t0zwd7okb6xjj9bm6w-1vapc6cnf1kwv0dfnt162km2t \
    10.101.0.22:2377
```
- manager01
```
$ docker node list
ID                           HOSTNAME     STATUS  AVAILABILITY  MANAGER STATUS
0run85wvbysq0803v82i4e6uo    swarm-z2-01  Ready   Active
2tgyqo1bma9npov3bb7vhetg1    swarm-z1-01  Ready   Active
9xobningonsptorguyv5bukfm *  swarm-1      Ready   Active        Leader
```


## Reference
- [Docker Swarm v1.12](https://docs.docker.com/engine/swarm/)
