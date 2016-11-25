
## Installation on Windows/Mac
- Go to DockerToolBox Site : https://www.docker.com/products/docker-toolbox
- Download & Install it
- Run Docker QuickStart Terminal

## 
- create vm
```
docker-machine create --driver virtualbox sample
```
- list vm
```
docker-machine ls
```
- ssh to vm
```
docker-machine ssh sample
```
- run docker image
```
docker run -d -p 8000:80 nginx
curl localhost:8000
exit
```
- test image in host
```
curl $(docker-machine ip default):8000
```
- remove vm
```
docker-machine rm sample
```

## Reference
- https://docs.docker.com/machine/
