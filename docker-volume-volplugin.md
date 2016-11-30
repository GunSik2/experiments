## docker - volplugin
- Nodes
```
docker-machine create -d openstack --openstack-availability-zone ZN_PAAS_01 node1 --openstack-floatingip-pool PN_PUB
docker-machine create -d openstack --openstack-availability-zone ZN_PAAS_02 node2
docker-machine create -d openstack --openstack-availability-zone ZN_PAAS_03 node3

docker-machine ssh node1 
sudo usermod -aG docker $USER
docker-machine ssh node2 
sudo usermod -aG docker $USER
docker-machine ssh node3 
sudo usermod -aG docker $USER

docker-machine ssh node1 docker swarm init --advertise-addr 10.101.0.255
docker-machine ssh node2 docker swarm join --token SWMTKN-1-59blm3t66ip3hgy7lvhjkh4c3kmrhyuzepqlvooyp4jqfvdxgf-bpht19gdj1k4f9ozegwowf87e 10.101.0.255:2377
docker-machine ssh node3 docker swarm join --token SWMTKN-1-59blm3t66ip3hgy7lvhjkh4c3kmrhyuzepqlvooyp4jqfvdxgf-bpht19gdj1k4f9ozegwowf87e 10.101.0.255:2377
```

- voplgin
```
docker-machine ssh node1 

-- systemd 사용하는 경우
sudo vi /lib/systemd/system/docker.service
[Service]
MountFlags=shared 

`systemctl daemon-reload` and `systemctl restart docker

-- upstart 사용하는 경우
sudo mount --make-shared /

docker run -it -v /var/run/docker.sock:/var/run/docker.sock contiv/volplugin-autorun
```


## ceph-flucker-driver

```
$ curl -sSL https://get.flocker.io/ | sh
$ mkdir -p ~/clusters/test
$ cd ~/clusters/test
```

## Ref:
- https://github.com/contiv/volplugin
- https://clusterhq.com/2016/04/27/ceph-flocker/
- https://github.com/ClusterHQ/ceph-flocker-driver
