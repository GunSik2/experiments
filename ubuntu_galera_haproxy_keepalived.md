## Env
- MariaDB 10.1

## Mariadb + Galera
### Common
```
sudo apt-get update
sudo apt-get install -y python-software-properties
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
sudo add-apt-repository 'deb [arch=amd64,i386] http://mariadb.biz.net.id/repo/10.1/ubuntu trusty main'

sudo apt-get update
sudo apt-get install -y mariadb-server

sudo vi /etc/hosts
mariadb01 172.31.11.130
mariadb02 172.31.11.131
mariadb03 172.31.11.132

sudo vi /etc/mysql/conf.d/cluster.cnf
[mysqld]
wsrep_cluster_address="gcomm://mariadb01, mariadb02, mariadb03"
innodb_buffer_pool_size=400M
wsrep_on=ON
wsrep_provider=/usr/lib/galera/libgalera_smm.so
binlog_format=ROW
default-storage-engine=InnoDB
innodb_autoinc_lock_mode=2
innodb_doublewrite=1
query_cache_size=0
wsrep_sst_method=rsync
#bind-address=0.0.0.0
```
- create ami image
- lauch additional two nodes using the ami image.

### Node1
- boot from ami image
- change config
```
sudo vi /etc/hosts
mariadb01 172.31.11.130
mariadb02 172.31.20.248
mariadb03 172.31.5.151

sudo vi /etc/mysql/conf.d/cluster.cnf
---
wsrep_cluster_address="gcomm://mariadb01, mariadb02, mariadb03"
#wsrep_node_address="mariadb-sf01.bbi.io"
---
sudo service mysql stop
sudo mysqld --wsrep-new-cluster &
```
### Node2
```
mysqld --wsrep_cluster_address=gcomm://172.31.11.130  # DNS names work as well
```
### Node3

### Test
```
mysql -u root -p
show status like 'wsrep_cluster_size';
show status like 'wsrep_%';
CREATE DATABASE playground;
CREATE TABLE playground.equipment ( id INT NOT NULL AUTO_INCREMENT, type VARCHAR(50), quant INT, color VARCHAR(25), PRIMARY KEY(id));
INSERT INTO playground.equipment (type, quant, color) VALUES ("slide", 2, "blue");
SELECT * FROM playground.equipment;
```
## Haproxy 

## Keepalived

## Test
### Failover
### Performance

## Reference
- https://mariadb.org/mariadb-10-1-1-galera-support/
- https://mariadb.com/kb/en/mariadb/getting-started-with-mariadb-galera-cluster/
- (5.5) https://mariadb.org/installing-mariadb-galera-cluster-on-debian-ubuntu/
- https://medium.com/@_wli/mariadb-galera-cluster-10-1-installation-on-digitalocean-ubuntu-14-04-65b7d18d06ec#.f3kklbuk3
- http://galeracluster.com/documentation-webpages/
- 
