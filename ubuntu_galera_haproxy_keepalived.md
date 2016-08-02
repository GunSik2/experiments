## Env
- MariaDB 10.1

## Mariadb + Galera
### Common
```
sudo apt-get update
sudo apt-get install python-software-properties
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
sudo add-apt-repository 'deb [arch=amd64,i386] http://mariadb.biz.net.id/repo/10.1/ubuntu trusty main'

sudo apt-get update
sudo apt-get install mariadb-server

sudo nano /etc/mysql/conf.d/cluster.cnf
[mysqld]
# Cluster node configurations
wsrep_cluster_address="gcomm://mariadb-sg01.bbi.io,mariadb-sg02.bbi.io,mariadb-sf01.bbi.io,mariadb-ny01.bbi.io,mariadb-ny02.bbi.io"
wsrep_node_address="mariadb-sg01.bbi.io"
innodb_buffer_pool_size=400M
# Mandatory settings to enable Galera
wsrep_on=ON
wsrep_provider=/usr/lib/galera/libgalera_smm.so
binlog_format=ROW
default-storage-engine=InnoDB
innodb_autoinc_lock_mode=2
innodb_doublewrite=1
query_cache_size=0
#bind-address=0.0.0.0
# Galera synchronisation configuration
wsrep_sst_method=rsync
```
- create ami image

### Node1
- boot from ami image
- change config
```
sudo vi /etc/mysql/conf.d/cluster.cnf
---
wsrep_cluster_address="gcomm://mariadb-sg01.bbi.io,mariadb-sg02.bbi.io,mariadb-sf01.bbi.io,mariadb-ny01.bbi.io,mariadb-ny02.bbi.io"
#wsrep_node_address="mariadb-sf01.bbi.io"
---
pkill -9 mysqld
service mysql restart
```
### Node2
```
```
### Node3

### Test
```
mysql -u root -p
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
- https://mariadb.org/installing-mariadb-galera-cluster-on-debian-ubuntu/
- https://medium.com/@_wli/mariadb-galera-cluster-10-1-installation-on-digitalocean-ubuntu-14-04-65b7d18d06ec#.f3kklbuk3
- http://galeracluster.com/documentation-webpages/
- 
