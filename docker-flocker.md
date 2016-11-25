

## Flucker installation

## Flucker usecase
### Storing data on a network-attached block device via the Flocker plug-in for Docker 
- Run container on host2
```
user@host2 $ docker run --volume-driver flocker -v flocker-volume:/container/dir --name=container-xyz
```

- Create your volume separately 
```
user@host1 $ docker volume create --name persistent-vol-1 -d flocker
user@host1 $ docker run -v persistent-vol-1:/container/dir
```


## Reference
- https://flocker-docs.clusterhq.com/en/latest/docker-integration/
- https://clusterhq.com/2015/12/09/difference-docker-volumes-flocker-volumes/
