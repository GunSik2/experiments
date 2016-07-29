
# MariaDB HA Cluster Options
High Availability Technologies
- MariaDB Enterprise Cluster
- [MariaDB Galera Cluster](https://downloads.mariadb.org/mariadb-galera/)
- MySQL Replication
- Semi-sync Replication
- DRBD in Active/Passive Mode
- DRBD in Active/Passive Mode + Passive/Active Mode
- DRBD in Active/Passive Mode + Replication
- Galera Cluster
- Master HA Tool with Multi-Tier Replication
- MySQL Cluster
- Linux Shared Storage
- Linux Shared Storage + Replication
- Windows 2008 Cluster Service & Windows 2008 Cluster Service + Replication.

Reference
- https://mariadb.com/services/mariadb-mysql-consulting/mariadb-high-availability

# MaridB Galera Cluster
- install cluster
```
cat > galera.yaml << EOF 
galera-cluster:
  root-password: my-root-password
  sst-password: my-sst-password
EOF

//juju deploy --config galera.yaml cs:galera-cluster
juju deploy --config galera.yaml cs:~codership/galera-cluster
juju add-unit galera-cluster

juju status galera-cluster --format short 
- galera-cluster/0: 52.197.251.49 (started) 3306/tcp

juju ssh galera-cluster/0 mysql -uroot -pmy-root-password
mysql> show status like '%wsrep_cluster_size%';
+--------------------+-------+
| Variable_name      | Value |
+--------------------+-------+
| wsrep_cluster_size | 1     |
+--------------------+-------+
```
- add cluster node
```
juju add-unit galera-cluster
juju add-unit galera-cluster

juju status galera-cluster --format short 
- galera-cluster/0: 52.197.251.49 (started) 3306/tcp
- galera-cluster/1: 52.69.57.99 (started) 3306/tcp
- galera-cluster/2: 52.68.40.218 (started) 3306/tcp

juju ssh galera-cluster/0 mysql -uroot -pmy-root-password
mysql> show status like '%wsrep_cluster_size%';
+--------------------+-------+
| Variable_name      | Value |
+--------------------+-------+
| wsrep_cluster_size | 3     |
+--------------------+-------+
```

- add vip
```
juju set galera-cluster vip=10.0.3.200 
juju deploy cs:trusty/hacluster-29   //juju deploy hacluster 
juju add-relation hacluster galera-cluster
juju expose galera-cluster
# ERROR cannot add relation "galera-cluster:ha hacluster:ha": principal and subordinate services' series must match
```

- zone 지정


Reference
- https://jujucharms.com/galera-cluster/
- https://mariadb.com/kb/en/mariadb/galera-cluster/
- http://galeracluster.com/2015/06/fast-galera-cluster-deployments-in-the-cloud-using-juju/

# Mariadb Scaleout
- https://mariadb.com/products/mariadb-maxscale/database-scaling

# Mariadb Cluster
- https://demo.jujucharms.com/?store=trusty/mariadb
