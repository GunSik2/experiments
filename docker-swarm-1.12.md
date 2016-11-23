## Docker Swarm

#### Installation
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

#### Test
- Deploy Service (manager01)
```
$ docker service create --replicas 1 --name helloworld alpine ping docker.com
$ docker service ls
```
- Inspect a service on the swarm (manager01)
```
$ docker service inspect --pretty helloworld
$ docker service inspect helloworld
$ docker service ps helloworld
$ docker ps  
```
- Scale the service in the swarm (manager01)
```
$ docker service scale helloworld=5
ID                         NAME          IMAGE   NODE         DESIRED STATE  CURRENT STATE           ERROR
0v687w0ozb0jh3xyqadq0c1v1  helloworld.1  alpine  swarm-1      Running        Running 3 minutes ago
0hzuewtpfd06tswmcw8sg0lci  helloworld.2  alpine  swarm-z2-01  Running        Running 23 seconds ago
5spi18heffn82t2as6nq5q9qd  helloworld.3  alpine  swarm-z1-01  Running        Running 23 seconds ago
20vapdwt8taogskewal0pqxzs  helloworld.4  alpine  swarm-z1-01  Running        Running 23 seconds ago
8nfhrxs34voob79aav1ludalh  helloworld.5  alpine  swarm-1      Running        Running 24 seconds ago
```
- Delete the service running on the swarm (manager01)
```
$ docker service rm helloworld
```
- Apply rolling updates to a service (manager01)
```
$ docker service create \
  --replicas 3 \
  --name redis \
  --update-delay 10s \
  redis:3.0.6

$ watch docker service ps redis
Every 2.0s: docker service ps redis   

ID                         NAME         IMAGE        NODE         DESIRED STATE  CURRENT STATE            ERROR
4745yflob8o66n9dfoesgcdnb  redis.1      redis:3.0.7  swarm-1      Running        Running 27 seconds ago
0vn5uvqqletbt2070a2aggmt1   \_ redis.1  redis:3.0.6  swarm-z2-01  Shutdown       Shutdown 42 seconds ago
9y8a0ylpiibv15hi08pcg8lz7  redis.2      redis:3.0.7  swarm-z2-01  Running        Running 1 seconds ago
ak683dy8j3o3k1kc36mfjfd2v   \_ redis.2  redis:3.0.6  swarm-z1-01  Shutdown       Shutdown 15 seconds ago
asq6n3n2p7bbmjhe5hywubc86  redis.3      redis:3.0.6  swarm-1      Running        Running 4 minutes ago

$ docker service inspect --pretty redis

$ docker service update redis  // update restart if the update fails
``` 
- Drain a node on the swarm (manager01)
```
$ docker node ls
ID                           HOSTNAME     STATUS  AVAILABILITY  MANAGER STATUS
0run85wvbysq0803v82i4e6uo    worker1      Ready   Active
2tgyqo1bma9npov3bb7vhetg1    worker2      Ready   Active
9xobningonsptorguyv5bukfm *  mamager1     Ready   Active        Leader

$ docker node update --availability drain worker1
$ docker service ps redis | | grep Run
4745yflob8o66n9dfoesgcdnb  redis.1      redis:3.0.7  mamager1 Running        Running 7 minutes ago
7c4o8gl76alyye15rduesqe43  redis.2      redis:3.0.7  worker2  Running        Running about a minute ago
ergvhxl8my9hone0zl7z3x2q3  redis.3      redis:3.0.7  worker2  Running        Running 6 minutes ago

$ docker node update --availability active worker1
$ docker node inspect --pretty worker1
```



## Reference
- [Docker Swarm v1.12](https://docs.docker.com/engine/swarm/)
