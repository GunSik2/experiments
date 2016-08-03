## Env
- MariaDB 5.5

## Mariadb + Galera
### Common
```
sudo apt-get update
sudo apt-get install -y python-software-properties
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
sudo add-apt-repository 'deb [arch=amd64,i386] http://mariadb.biz.net.id/repo/5.5/ubuntu trusty main'
sudo apt-get update

DEBIAN_FRONTEND=noninteractive sudo apt-get install -y rsync galera mariadb-galera-server

sudo vi /etc/mysql/conf.d/galera.cnf
[mysqld]
#mysql settings
binlog_format=ROW
default-storage-engine=innodb
innodb_autoinc_lock_mode=2
query_cache_size=0
query_cache_type=0
bind-address=0.0.0.0

#galera settings
wsrep_provider=/usr/lib/galera/libgalera_smm.so
wsrep_cluster_name="my_wsrep_cluster"
wsrep_cluster_address="gcomm://172.16.8.5,172.16.8.6,172.16.8.4"
wsrep_sst_method=rsync
```


### Each node
```
node01# sudo service mysql stop
node02# sudo service mysql stop
node03# sudo service mysql stop
```

```
node01# sudo service mysql start --wsrep-new-cluster
node01# mysql -u root -p -e 'SELECT VARIABLE_VALUE as "cluster size" FROM INFORMATION_SCHEMA.GLOBAL_STATUS WHERE VARIABLE_NAME="wsrep_cluster_size"'
```

```
node2# sudo service mysql start
[ ok ] Starting MariaDB database server: mysqld . . . . . . . . . ..
[info] Checking for corrupt, not cleanly closed and upgrade needing tables..
node01:/home/debian# ERROR 1045 (28000): Access denied for user 'debian-sys-maint'@'localhost' (using password: YES)
node2# mysql -u root -p -e 'SELECT VARIABLE_VALUE as "cluster size" FROM INFORMATION_SCHEMA.GLOBAL_STATUS WHERE VARIABLE_NAME="wsrep_cluster_size"'
```

```
node3# sudo service mysql start
[ ok ] Starting MariaDB database server: mysqld . . . . . . . . . ..
[info] Checking for corrupt, not cleanly closed and upgrade needing tables..
node03:/home/debian# ERROR 1045 (28000): Access denied for user 'debian-sys-maint'@'localhost' (using password: YES)
node03# mysql -u root -p -e 'SELECT VARIABLE_VALUE as "cluster size" FROM INFORMATION_SCHEMA.GLOBAL_STATUS WHERE VARIABLE_NAME="wsrep_cluster_size"'
```

```
#1의 설정을 #2, #3 로 복제
node1# sudo scp -i pem /etc/mysql/debian.cnf ubuntu@node2:/etc/mysql/debian.cnf
node1# sudo scp -i pem /etc/mysql/debian.cnf ubuntu@node3:/etc/mysql/debian.cnf
````

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
