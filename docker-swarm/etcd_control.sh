#!/bin/bash


function ps() {
docker-machine ssh swarm-1 "sudo docker ps -a "
docker-machine ssh swarm-2 "sudo docker ps -a "
docker-machine ssh swarm-3 "sudo docker ps -a "
}

function start() {
docker-machine ssh swarm-1 "bash -s" < etcd_cluster.sh etcd1
sleep 1
docker-machine ssh swarm-2 "bash -s" < etcd_cluster.sh etcd2
sleep 1
docker-machine ssh swarm-3 "bash -s" < etcd_cluster.sh etcd3
}

function kill() {
docker-machine ssh swarm-1 "sudo docker stop etcd; sudo docker rm etcd"
docker-machine ssh swarm-2 "sudo docker stop etcd; sudo docker rm etcd"
docker-machine ssh swarm-3 "sudo docker stop etcd; sudo docker rm etcd"
}

echo "ps | start | kill"
echo "$*"

$*
