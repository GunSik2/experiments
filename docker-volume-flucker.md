## Introduction


## Flucker
- Installing the Flocker Client
```
sudo apt-get update
sudo apt-get -y install apt-transport-https software-properties-common
sudo add-apt-repository -y "deb https://clusterhq-archive.s3.amazonaws.com/ubuntu/$(lsb_release --release --short)/\$(ARCH) /"
cat <<EOF > /tmp/apt-pref
Package: *
Pin: origin clusterhq-archive.s3.amazonaws.com
Pin-Priority: 700
EOF
sudo mv /tmp/apt-pref /etc/apt/preferences.d/buildbot-700
sudo apt-get update
sudo apt-get -y install --force-yes clusterhq-flocker-cli
```

- Installing the Flocker Node Services
```
```

## Flucker Docker
- Installation
```
git clone https://github.com/ClusterHQ/flocker-ceph-driver
cd flocker-ceph-driver/
sudo /opt/flocker/bin/python setup.py install
```

- Test
```
$ vagrant ssh node1
vagrant@node1:~$ docker run --rm --volume-driver flocker -v simple:/data busybox sh -c "echo hello > /data/file.txt"
vagrant@node1:~$ exit

$ vagrant ssh node2
vagrant@node2:~$ docker run --rm --volume-driver flocker -v simple:/data busybox sh -c "cat /data/file.txt"
hello
vagrant@node2:~$ exit
```


## Docker ceph

- Installation
```
sudo docker run -d --net=host -v /etc/ceph:/etc/ceph -e MON_IP=192.168.99.100 -e CEPH_PUBLIC_NETWORK=192.168.99.0/24 ceph/demo
```


## Reference
- https://flocker-docs.clusterhq.com/en/latest/docker-integration/manual-install.html
- https://clusterhq.com/2016/04/27/ceph-flocker/
- https://flocker-docs.clusterhq.com/en/latest/supported/index.html
- https://github.com/ClusterHQ/ceph-flocker-driver
- https://github.com/ceph/ceph-docker
- https://flocker-docs.clusterhq.com/en/latest/flocker-standalone/manual-install.html
