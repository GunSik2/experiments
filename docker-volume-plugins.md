
# Inctroduction
- Strategies to Manage Persistent Data
  - Host-Based Persistence :  data residing on the host
    - Implicit Per-Container Storage
    - Explicit Shared Storage (Data Volumes)
  - Shared Multi-Host Storage
- Software-Defined Storage Providers (Storage-as-a-Service)  
  -  Portworx, Hedvig, CoreOS Torus, EMC libStorage, Joyent Manta and Blockbridge
  -  StorageOS, Robin Systems and Quobyte 

- Multi-host volume support plug-ins 
  - [Blockbridge plugin](https://github.com/blockbridge/blockbridge-docker-volume)
  - [ClusterHQ Flocker plugin]()
    - Supports Docker Swarm, Kubernetes and Mesos
    - Supports Amazon Elastic Block Store (EBS), GCE persistent disk, OpenStack Cinder, vSphere, vSAN and more
  - GlusterFS plugin
  - [EMC LibStorage (Apache Lincense)]( https://github.com/codedellemc/libstorage)
    - Supports Amazon Elastic Block Store (EBS), AWS EFS, VirtualBox, ScaleIO, Lsilon
   - [Joynet Manta](https://github.com/joyent/manta/)

# Architecture
- Docker Volume Plugin Architecture

![Third-party volume plugin](http://thenewstack.io/wp-content/uploads/2016/09/Chart_Docker-Volume-Plugin-Architecture.png)

- Flocker

[Flocker](https://sreeninet.files.wordpress.com/2015/07/flocker2.png)



# Reference
- https://docs.docker.com/engine/extend/legacy_plugins/ 
- http://thenewstack.io/methods-dealing-container-storage/
