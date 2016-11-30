
## Convoy plugin

- Install
```
wget https://github.com/rancher/convoy/releases/download/v0.5.0/convoy.tar.gz
tar xvf convoy.tar.gz
sudo cp convoy/convoy convoy/convoy-pdata_tools /usr/local/bin/
sudo mkdir -p /etc/docker/plugins/
sudo bash -c 'echo "unix:///var/run/convoy/convoy.sock" > /etc/docker/plugins/convoy.spec'
```

- Create Convoy Device Mapper driver
  - file-backed loopback device
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
``
sudo convoy create res1 --backup <backup_url>
sudo docker run -v res1:/res1 --volume-driver=convoy ubuntu ls -l /res1
```

