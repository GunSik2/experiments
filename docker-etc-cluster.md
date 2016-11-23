

## Cluster option
- Static : we know the cluster members, their addresses and the size of the cluster before starting, 
- etcd Discovery : New etcd member discover all other members in cluster bootstrap phase using a shared discovery URL
- DNS Discovery : DNS SRV records can be used as a discovery mechanism


## Reference
- [etcd cluster guide](https://coreos.com/etcd/docs/latest/clustering.html)
- [Building a Robust etcd cluster in AWS](https://crewjam.com/etcd-aws/)
