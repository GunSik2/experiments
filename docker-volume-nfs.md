## NFS Service 
### NFS Insall
- install
```
sudo apt-get install -y nfs-kernel-server
```
- config
```
sudo mkdir /var/shared
sudo chmod a+rwx /var/shared/.
sudo vi /etc/exports
/var/shared *(rw,sync,no_root_squash)
```
- run nfs
```
sudo service nfs-kernel-server start
```
- client test
```
sudo apt-get install nfs-common
mkdir /tmp/shared
sudo mount <nfs_server_ip>:/var/shared /shared
df -h
echo hello > /tmp/shared/aa
```
### Docker-NFS ==> failed
- Install pulgin
```
$ git clone https://github.com/SvenDowideit/docker-volumes-nfs
$ cd docker-volumes-nfs
$ sudo apt-get install make
$ make build
+ exec go get -v -d
github.com/docker/go-plugins-helpers (download)
cd .; git clone https://github.com/docker/go-plugins-helpers /go/src/github.com/docker/go-plugins-helpers
Cloning into '/go/src/github.com/docker/go-plugins-helpers'...
fatal: unable to access 'https://github.com/docker/go-plugins-helpers/': gnutls_handshake() failed: Error in the pull function.
package github.com/docker/go-plugins-helpers/volume: exit status 128
 ==> failed
$ make containerrun
```
- nfs://127.0.0.1:/data
 - because of the way docker parses colons, you need to omit them from the NFS share.
```
docker run --rm -it --volume-driver=nfs -v 127.0.0.1/data:/no busybox ls -la
```

Reference
- [List of Docker Volume Drivers](https://huaminchen.wordpress.com/2015/10/22/list-of-docker-volume-drives/)
- [Docker volume nfs mounter](https://github.com/SvenDowideit/docker-volumes-nfs)
