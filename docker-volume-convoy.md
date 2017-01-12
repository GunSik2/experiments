Using Convoy with Docker
========================

## Objective
How to use convoy with docker to provide shared volume?


## Docker with Convoy
Any existing Convoy volume would be refered by it's name in Docker.

### Register Convoy plugin to Docker
```
sudo mkdir -p /etc/docker/plugins/
sudo bash -c 'echo "unix:///var/run/convoy/convoy.sock" > /etc/docker/plugins/convoy.spec'
```
### Managing Volume
- Using convoy cli
```
sudo convoy create new_volume --driver ebs --size 10G --type io1 --iops 200
sudo convoy delete -r new_volume
```
- Using docker volume
```
sudo docker volume create --name new_volume --volume-driver=convoy --opt driver=ebs --opt size=10G --opt type=io1 --opt iops=200
sudo docker volume rm new_volume
```

### Create Container
- Using default convoy driver opetion
```
sudo docker run -name db_container -v db_vol:/var/lib/mysql/ --volume-driver=convoy mariadb
sudo convoy inspect db_vol
```
- Using custom driver option
```
sudo convoy create db_container --driver ebs --size 10G --type io1 --iops 200
sudo docker run -name db_container -v db_vol:/var/lib/mysql/ --volume-driver=convoy mariadb
```
### Delete Container
- By default, Docker doesn't delete volume associated with container when container got deleted. 
```
sudo docker rm db_container
sudo convoy inspect db_vol  // would show
```

- In order to delete volume associate with Docker, you would need --volume/-v parameter of docker rm:
```
sudo docker rm -v db_container
sudo convoy inspect db_vol  // would error out
```
 
 
## Convoy plugins
- Introduction
  - Backends supported by Convoy currently
    - Device Mapper
    - Virtual File System(VFS)/Network File System(NFS)
    - Amazon Elastic Block Store(EBS)
    - GlusterFS
- Structure

![](http://img.scoop.it/qhnikgXThUYMjh8Ll8RuQzl72eJkfbmt4t8yenImKBVvK0kTmF0xjctABnaLJIm9)


### Convoy Installation 
```
wget https://github.com/rancher/convoy/releases/download/v0.5.0/convoy.tar.gz
tar xvf convoy.tar.gz
sudo cp convoy/convoy convoy/convoy-pdata_tools /usr/local/bin/
sudo mkdir -p /etc/docker/plugins/
sudo bash -c 'echo "unix:///var/run/convoy/convoy.sock" > /etc/docker/plugins/convoy.spec'
```

## Convoy with Device Mapper Driver

- Create Convoy Device Mapper driver
  - create file-backed loopback device
```
truncate -s 10G data.vol
truncate -s 1G metadata.vol
sudo losetup /dev/loop5 data.vol
sudo losetup /dev/loop6 metadata.vol
```

- Start Convoy plugin daemon 
```
sudo convoy daemon --drivers devicemapper --driver-opts dm.datadev=/dev/loop5 --driver-opts dm.metadatadev=/dev/loop6
```

- Test:  Docker container with a convoy volume
```
sudo docker run -v vol1:/vol1 --volume-driver=convoy ubuntu touch /vol1/foo
sudo docker run -it -v vol1:/vol1 --volume-driver=convoy ubuntu bash
# ls /vol1/foo
# exit
```

- Test : Backup 
```
$ sudo convoy snapshot create vol1 --name snap1vol1
$ sudo mkdir -p /opt/convoy/
$ sudo convoy backup create snap1vol1 --dest vfs:///opt/convoy/
vfs:///opt/convoy/?backup=backup-f8649df9c27b4750\u0026volume=vol1
```

- Test : Recover
  - You should see the recovered file /res1/foo
```
sudo convoy create res1 --backup <backup_url>
sudo docker run -v res1:/res1 --volume-driver=convoy ubuntu ls -l /res1
```

## Convoy with GlusterFS
Convoy can leveage GlusterFS to create volumes for Docker container. Snapshot and Backup are not supported at this stage.

- Start Convoy plugin daemon 
  - glusterfs.servers: Can be host name or IP address. Separate by "," without space
  - glusterfs.defaultvolumepool: The default GlusterFS volume name which would be used to create container volumes
```
sudo convoy daemon --drivers devicemapper --driver-opts glusterfs.servers=10.1.1.2,10.1.1.3,10.1.1.4 --driver-opts glusterfs.defaultvolumepool=docker-volume
```

- Create
  - Create a directory at mounted path of default GlusterFS volume, and use that directory to store volume.
  - If the directory named volume_name already existed, it would be used instead of creating a new directory for volume.
  - The default GlusterFS volume is mounted to /var/lib/convoy/glusterfs/mounts/my_vol
```
$ sudo convoy create vol1
```

- Delete
  - Delete the directory where the volume stored by default.
  - **--reference** would only delete the reference of volume in Convoy. It would preserve the volume directory for future use.
```
$ sudo convoy delete vol1
$ sudo convoy delete vol1 --reference
```

- Inspect
  -  Provides following informations at DriverInfo section: Name, Path, MountPoint, GlusterFSVolume, GlusterFSServers
```
$ sudo convoy inspect vol1
```

- Info
  -  provides following informations at vfs section: Root, GlusterFSServers, DefaultVolumePool
```
$ sudo convoy info vol1
```



## Reference
- https://github.com/rancher/convoy
- https://docs.docker.com/engine/extend/legacy_plugins/
- https://github.com/rancher/convoy/blob/master/docs/glusterfs.md
