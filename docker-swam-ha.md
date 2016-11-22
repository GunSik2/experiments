


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
- [CEPH GETTING STARTED WITH THE DOCKER RBD VOLUME PLUGIN](http://ceph.com/planet/getting-started-with-the-docker-rbd-volume-plugin/)
- [Docker - CEPH : Contiv volplugin](https://github.com/contiv/volplugin)
