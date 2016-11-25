
## Installation on Windows/Mac
- Go to DockerToolBox Site : https://www.docker.com/products/docker-toolbox
- Download & Install it
- Run Docker QuickStart Terminal

## Using Docker Machine
- create vm
```
docker-machine create --driver virtualbox sample
```
- list vm
```
docker-machine ls
```
- ssh to vm
```
docker-machine ssh sample
```
- run docker image
```
docker run -d -p 8000:80 nginx
curl localhost:8000
exit
```
- test image in host
```
curl $(docker-machine ip default):8000
```
- remove vm
```
docker-machine rm sample
```
## Virtualbox driver configuration
- driver options
```
$ docker-machine create -d virtualbox --help
Usage: docker-machine create [OPTIONS] [arg...]

Create a machine

Description:
   Run 'D:\Software\Docker Toolbox\docker-machine.exe create --driver name' to include the create flags for that driver in the help text.

Options:

   --driver, -d "none"                                                                                  Driver to create machine with. [$MACHINE_DRIVER]
   --engine-env [--engine-env option --engine-env option]                                               Specify environment variables to set in the engine
   --engine-insecure-registry [--engine-insecure-registry option --engine-insecure-registry option]     Specify insecure registries to allow with the created engine
   --engine-install-url "https://get.docker.com"                                                        Custom URL to use for engine installation [$MACHINE_DOCKER_INSTALL_URL]
   --engine-label [--engine-label option --engine-label option]                                         Specify labels for the created engine
   --engine-opt [--engine-opt option --engine-opt option]                                               Specify arbitrary flags to include with the created engine in the form flag=value
   --engine-registry-mirror [--engine-registry-mirror option --engine-registry-mirror option]           Specify registry mirrors to use [$ENGINE_REGISTRY_MIRROR]
   --engine-storage-driver                                                                              Specify a storage driver to use with the engine
   --swarm                                                                                              Configure Machine to join a Swarm cluster
   --swarm-addr                                                                                         addr to advertise for Swarm (default: detect and use the machine IP)
   --swarm-discovery                                                                                    Discovery service to use with Swarm
   --swarm-experimental                                                                                 Enable Swarm experimental features
   --swarm-host "tcp://0.0.0.0:3376"                                                                    ip/socket to listen on for Swarm master
   --swarm-image "swarm:latest"                                                                         Specify Docker image to use for Swarm [$MACHINE_SWARM_IMAGE]
   --swarm-join-opt [--swarm-join-opt option --swarm-join-opt option]                                   Define arbitrary flags for Swarm join
   --swarm-master                                                                                       Configure Machine to be a Swarm master
   --swarm-opt [--swarm-opt option --swarm-opt option]                                                  Define arbitrary flags for Swarm master
   --swarm-strategy "spread"                                                                            Define a default scheduling strategy for Swarm
   --tls-san [--tls-san option --tls-san option]                                                        Support extra SANs for TLS certs
   --virtualbox-boot2docker-url                                                                         The URL of the boot2docker image. Defaults to the latest available version [$VIRTUALBOX_BOOT2DOCKER_URL]
   --virtualbox-cpu-count "1"                                                                           number of CPUs for the machine (-1 to use the number of CPUs available) [$VIRTUALBOX_CPU_COUNT]
   --virtualbox-disk-size "20000"                                                                       Size of disk for host in MB [$VIRTUALBOX_DISK_SIZE]
   --virtualbox-host-dns-resolver                                                                       Use the host DNS resolver [$VIRTUALBOX_HOST_DNS_RESOLVER]
   --virtualbox-hostonly-cidr "192.168.99.1/24"                                                         Specify the Host Only CIDR [$VIRTUALBOX_HOSTONLY_CIDR]
   --virtualbox-hostonly-nicpromisc "deny"                                                              Specify the Host Only Network Adapter Promiscuous Mode [$VIRTUALBOX_HOSTONLY_NIC_PROMISC]
   --virtualbox-hostonly-nictype "82540EM"                                                              Specify the Host Only Network Adapter Type [$VIRTUALBOX_HOSTONLY_NIC_TYPE]
   --virtualbox-import-boot2docker-vm                                                                   The name of a Boot2Docker VM to import [$VIRTUALBOX_BOOT2DOCKER_IMPORT_VM]
   --virtualbox-memory "1024"                                                                           Size of memory for host in MB [$VIRTUALBOX_MEMORY_SIZE]
   --virtualbox-nat-nictype "82540EM"                                                                   Specify the Network Adapter Type [$VIRTUALBOX_NAT_NICTYPE]
   --virtualbox-no-dns-proxy                                                                            Disable proxying all DNS requests to the host [$VIRTUALBOX_NO_DNS_PROXY]
   --virtualbox-no-share                                                                                Disable the mount of your home directory [$VIRTUALBOX_NO_SHARE]
   --virtualbox-no-vtx-check                                                                            Disable checking for the availability of hardware virtualization before the vm is started [$VIRTUALBOX_NO_VTX_CHECK]
   --virtualbox-ui-type "headless"                                                                      Specify the UI Type: (gui|sdl|headless|separate) [$VIRTUALBOX_UI_TYPE]
```
- Environment variables and default values
```
CLI option	                        Environment variable	              Default
--virtualbox-memory	                VIRTUALBOX_MEMORY_SIZE	            1024
--virtualbox-cpu-count	            VIRTUALBOX_CPU_COUNT	              1
--virtualbox-disk-size	            VIRTUALBOX_DISK_SIZE	              20000
--virtualbox-host-dns-resolver	    VIRTUALBOX_HOST_DNS_RESOLVER	      false
--virtualbox-boot2docker-url	      VIRTUALBOX_BOOT2DOCKER_URL	        Latest boot2docker url
--virtualbox-import-boot2docker-vm	VIRTUALBOX_BOOT2DOCKER_IMPORT_VM	  boot2docker-vm
--virtualbox-hostonly-cidr	        VIRTUALBOX_HOSTONLY_CIDR	          192.168.99.1/24
--virtualbox-hostonly-nictype	      VIRTUALBOX_HOSTONLY_NIC_TYPE	      82540EM
--virtualbox-hostonly-nicpromisc	  VIRTUALBOX_HOSTONLY_NIC_PROMISC	    deny
--virtualbox-no-share	              VIRTUALBOX_NO_SHARE	                false
--virtualbox-no-dns-proxy	          VIRTUALBOX_NO_DNS_PROXY	            false
--virtualbox-no-vtx-check	          VIRTUALBOX_NO_VTX_CHECK	            false
```
## [Supported Drivers](https://docs.docker.com/machine/drivers/)
- Drivers
  - Amazon Web Services
  - Microsoft Azure
  - Digital Ocean
  - Exoscale
  - Google Compute Engine
  - Generic
  - Microsoft Hyper-V
  - OpenStack
  - Rackspace
  - IBM Softlayer
  - Oracle VirtualBox
  - VMware vCloud Air
  - VMware Fusion
  - VMware vSphere


## Reference
- [Docker Machine Document](https://docs.docker.com/machine/)
- [Oracle VirtualBox Driver](https://docs.docker.com/machine/drivers/virtualbox/)
