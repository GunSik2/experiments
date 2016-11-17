
## Overview
This is experiment for cloudfoundry mongodb service broker. 
We will deploy mongodb cluster and mongodb service in a single node. 
Env: ubuntu 16.04 servver

## Mongodb
#### Architecture

![Architecture](http://www.sohamkamani.com/assets/images/posts/docker-mongo-replication/architecture-diagram.png)

#### Installation

```
sudo apt install docker.io
sudo docker pull mongo

# Setting up the network
sudo docker network ls
sudo docker network create my-mongo-cluster

# Setting up our containers
# run each of these commands in a separate terminal window
sudo docker run -p 30001:27017 --name mongo1 --net my-mongo-cluster mongo mongod --replSet my-mongo-set
sudo docker run -p 30002:27017 --name mongo2 --net my-mongo-cluster mongo mongod --replSet my-mongo-set
sudo docker run -p 30003:27017 --name mongo3 --net my-mongo-cluster mongo mongod --replSet my-mongo-set

# Setting up replication
sudo docker exec -it mongo1 mongo
> db = (new Mongo('localhost:27017')).getDB('test')
> config = {
        "_id" : "my-mongo-set",
        "members" : [
                {
                        "_id" : 0,
                        "host" : "mongo1:27017"
                },
                {
                        "_id" : 1,
                        "host" : "mongo2:27017"
                },
                {
                        "_id" : 2,
                        "host" : "mongo3:27017"
                }
        ]
}
> rs.initiate(config)
{ "ok" : 1 }
my-mongo-set:OTHER> db.mycollection.insert({name : 'sample'})
my-mongo-set:PRIMARY> db.mycollection.find()
my-mongo-set:PRIMARY> db2 = (new Mongo('mongo2:27017')).getDB('test')
my-mongo-set:PRIMARY> db2.setSlaveOk()
my-mongo-set:PRIMARY> db2.mycollection.find()
```

## Reference
- [mongodb docker cluster](http://www.sohamkamani.com/blog/2016/06/30/docker-mongo-replica-set/)
- mongodb service broker - [broker-sample](https://github.com/spring-cloud-samples/cloudfoundry-service-broker)  [pivital](https://github.com/cf-platform-eng/mongodb-broker)

