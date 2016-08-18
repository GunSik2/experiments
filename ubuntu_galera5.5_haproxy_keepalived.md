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
- Install
```
sudo apt-get install keepalived
```
- Config
```
global_defs {
    notification_email {
      youremail@yourdomain.com
    }
    notification_email_from haproxy1@yourdomain.com
    smtp_server yoursmtp.yourdomain.com
    smtp_connect_timeout 30
    router_id haproxy
 }
 vrrp_script haproxy {
   script "killall -0 haproxy"
   interval 2
   weight 2
 }
 vrrp_instance VI_1 {
     state MASTER
     interface eth0
     virtual_router_id 71
     priority 100    # For node2, set priority to lower
     advert_int 1
     smtp_alert
     authentication {
         auth_type PASS
         auth_pass YourSecretPassword
     }
     virtual_ipaddress {
         192.168.1.3 dev eth0
     }
     track_script {
       haproxy
     }
 }
```
## Test
```
tcpdump -v -i eth0 host 224.0.0.18
tcpdump -vvv -n -i eth0 host 224.0.0.18
```


## Reference
- (5.5) https://mariadb.org/installing-mariadb-galera-cluster-on-debian-ubuntu/
- (keeyalived) https://blog.logentries.com/2014/12/keepalived-and-haproxy-in-aws-an-exploratory-guide/
- http://www.stratoscale.com/blog/compute/highly-available-lb-openstack-instead-lbaas/
