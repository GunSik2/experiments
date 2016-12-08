

## Install
- docker-ahcine
```
curl -L https://github.com/docker/machine/releases/download/v0.8.2/docker-machine-`uname -s`-`uname -m` > docker-machine 
chmod +x docker-machine
sudo mv docker-machine /usr/local/bin/
docker-machine version
```
- cloudstack driver
```
wget https://github.com/atsaki/docker-machine-driver-cloudstack/releases/download/v0.1.4/docker-machine-driver-cloudstack_linux_amd64
chmod +x docker-machine-driver-cloudstack_linux_amd64
sudo mv docker-machine-driver-cloudstack_linux_amd64 /usr/local/bin/docker-machine-driver-cloudstack
docker-machine create -d cloudstack --help
```

## Run
- create a new machine
```
docker-machine create -d cloudstack \
  --cloudstack-api-url CLOUDSTACK_API_URL \
  --cloudstack-api-key CLOUDSTACK_API_KEY \
  --cloudstack-secret-key CLOUDSTACK_SECRET_KEY \
  --cloudstack-template "Ubuntu Server 14.04" \
  --cloudstack-zone "zone01" \
  --cloudstack-service-offering "Small" \
  --cloudstack-expunge \
  docker-machine
```
