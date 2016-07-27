
# Env
- ubuntu 14.04
- iaas: openstack mikata

# Juju installation
```
ssh-keygen -t rsa -b 2048
sudo add-apt-repository ppa:juju/stable
sudo apt-get update && sudo apt-get install juju-core
juju init 

vi ~/.juju/environments.yaml
# 설정 변경
default: openstack
  openstack:
    type: openstack
    use-floating-ip: false
    use-default-secgroup: false
    network: BOSH
    auth-url: http://10.0.2.2:5000/v2.0
    region: RegionOne
    auth-mode: userpass
    tenant-name: demo
    username: demo
    password: thepassword
  amazon:
        type: ec2
        region: ap-northeast-1
        access-key: <secret>
        secret-key: <secret>
        
sudo mkdir /opt/stack
sudo chown ubuntu.ubuntu /opt/stack -R
juju metadata generate-image -a amd64 -i a3b30884-1bfa-46bd-84cb-32f9316cba6b -r RegionOne -s trusty -d /opt/stack -u http://10.1.1.33:5000/v2.0 -e openstack
juju metadata generate-tools -d /opt/stack
juju bootstrap --metadata-source /opt/stack --upload-tools -v
--
ubuntu@mgmt:~$ juju bootstrap --metadata-source /opt/stack --upload-tools -v
WARNING ignoring environments.yaml: using bootstrap config in file "/home/ubuntu/.juju/environments/openstack.jenv"
ERROR failed to bootstrap environment: index file has no data for cloud {RegionOne http://148.1.1.33:5000/v2.0} not found
--
juju ssh 0
```

# Juju test
```
juju bootstrap
juju deploy wordpress
juju deploy mysql
juju add-relation wordpress mysql
juju expose wordpress
juju status
juju destroy-environment 
```

# Juju frequently used commands
```
juju bootstrap -v
juju status
juju destory-environment
```


# Juju MySQL w/ Galera
- MySQL package : MariaDB w/ Galera

- Deployment
```
cat > galera.yaml << EOF 
galera-cluster:
 root-password: my-root-password
 sst-password: my-sst-password 
EOF

# Deploy the first node
juju deploy --config galera.yaml cs:~codership/galera-cluster
juju status
juju status galera-cluster

# Deploy the second node
juju add-unit galera-cluster
juju status --format short galera-cluster

# Check two node
juju ssh galera-cluster/0 mysql -uroot -pmy-root-password
mysql> show status like '%wsrep_cluster_size%';

# Permit access to the DB
juju expose galera-cluster
juju ssh galera-cluster/0 mysql -uroot -pmy-root-password
mysql> CREATE USER 'my-user'@'223.62.212.71' IDENTIFIED BY 'my-password';
juju unexpose galera-cluster

# Deploy vip for galera cluster
# 참고: ec2 는 multicast를 지원하지 않아 hacluster 구성이 불가
juju set galera-cluster vip=10.0.3.200   52.197.70.41
juju deploy hacluster 
juju status
juju add-relation hacluster galera-cluster

# 삭제
juju remove-unit galera-cluster/0 galera-cluster/1
juju remove-machine <number>
juju destroy-environment <environment>
```


# Reference
- [Juju getting started](https://jujucharms.com/docs/1.24/getting-started)
- [] (https://blog.felipe-alfaro.com/2014/04/29/bootstraping-juju-on-top-of-an-openstack-private-cloud/)
- [Juju openstack HA](https://wiki.ubuntu.com/ServerTeam/OpenStackHA)
