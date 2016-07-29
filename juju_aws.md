
# Env
- juju 1.25
- ubuntu 14.04
- iaas: aws

# Juju installation
```
ssh-keygen -t rsa -b 2048
sudo add-apt-repository ppa:juju/stable
sudo apt-get -y update && sudo apt-get install juju-core
juju init 

vi ~/.juju/environments.yaml
# 설정 변경
default: amazon
  amazon:
        type: ec2
        region: ap-northeast-1
        access-key: <secret>
        secret-key: <secret>
        
juju bootstrap -v
juju status
juju ssh 0
```

# Juju test
```
juju deploy wordpress
juju deploy mysql
juju add-relation wordpress mysql
juju expose wordpress
juju status
juju remove-service mysql
juju remove-service wordpress
juju destroy-environment 
```
# Juju model
```
$ juju status
environment: amazon
machines:
  "0":
    agent-state: started
    agent-version: 1.25.6
    dns-name: 10.197.233.154
    instance-id: i-4e84d9d1
    instance-state: running
    series: xenial
    hardware: arch=amd64 cpu-cores=1 cpu-power=300 mem=3840M root-disk=8192M availability-zone=ap-northeast-1a
    state-server-member-status: has-vote
  "1":
    agent-state: started
    agent-version: 1.25.6
    dns-name: 10.197.194.164
    instance-id: i-cea5a741
    instance-state: running
    series: trusty
    hardware: arch=amd64 cpu-cores=1 cpu-power=300 mem=3840M root-disk=8192M availability-zone=ap-northeast-1c
  "2":
    agent-state: started
    agent-version: 1.25.6
    dns-name: 10.197.206.78
    instance-id: i-57bee3c8
    instance-state: running
    series: trusty
    hardware: arch=amd64 cpu-cores=1 cpu-power=300 mem=3840M root-disk=8192M availability-zone=ap-northeast-1a
services:
  mysql:
    charm: cs:trusty/mysql-55
    exposed: false
    service-status:
      current: unknown
      since: 29 Jul 2016 02:06:40Z
    relations:
      cluster:
      - mysql
      db:
      - wordpress
    units:
      mysql/0:
        workload-status:
          current: unknown
          since: 29 Jul 2016 02:06:40Z
        agent-status:
          current: idle
          since: 29 Jul 2016 02:06:47Z
          version: 1.25.6
        agent-state: started
        agent-version: 1.25.6
        machine: "2"
        open-ports:
        - 3306/tcp
        public-address: 10.197.206.78
  wordpress:
    charm: cs:trusty/wordpress-4
    exposed: true
    service-status:
      current: unknown
      since: 29 Jul 2016 02:03:33Z
    relations:
      db:
      - mysql
      loadbalancer:
      - wordpress
    units:
      wordpress/0:
        workload-status:
          current: unknown
          since: 29 Jul 2016 02:03:33Z
        agent-status:
          current: executing
          message: running db-relation-changed hook
          since: 29 Jul 2016 02:06:47Z
          version: 1.25.6
        agent-state: started
        agent-version: 1.25.6
        machine: "1"
        open-ports:
        - 80/tcp
        public-address: 10.197.194.164
ubuntu@ip-172-31-4-186:~$ juju status
environment: amazon
machines:
  "0":
    agent-state: started
    agent-version: 1.25.6
    dns-name: 10.197.233.154
    instance-id: i-4e84d9d1
    instance-state: running
    series: xenial
    hardware: arch=amd64 cpu-cores=1 cpu-power=300 mem=3840M root-disk=8192M availability-zone=ap-northeast-1a
    state-server-member-status: has-vote
  "1":
    agent-state: started
    agent-version: 1.25.6
    dns-name: 10.197.194.164
    instance-id: i-cea5a741
    instance-state: running
    series: trusty
    hardware: arch=amd64 cpu-cores=1 cpu-power=300 mem=3840M root-disk=8192M availability-zone=ap-northeast-1c
  "2":
    agent-state: started
    agent-version: 1.25.6
    dns-name: 10.197.206.78
    instance-id: i-57bee3c8
    instance-state: running
    series: trusty
    hardware: arch=amd64 cpu-cores=1 cpu-power=300 mem=3840M root-disk=8192M availability-zone=ap-northeast-1a
services:
  mysql:
    charm: cs:trusty/mysql-55
    exposed: false
    service-status:
      current: unknown
      since: 29 Jul 2016 02:06:40Z
    relations:
      cluster:
      - mysql
      db:
      - wordpress
    units:
      mysql/0:
        workload-status:
          current: unknown
          since: 29 Jul 2016 02:06:40Z
        agent-status:
          current: idle
          since: 29 Jul 2016 02:06:47Z
          version: 1.25.6
        agent-state: started
        agent-version: 1.25.6
        machine: "2"
        open-ports:
        - 3306/tcp
        public-address: 10.197.206.78
  wordpress:
    charm: cs:trusty/wordpress-4
    exposed: true
    service-status:
      current: unknown
      since: 29 Jul 2016 02:03:33Z
    relations:
      db:
      - mysql
      loadbalancer:
      - wordpress
    units:
      wordpress/0:
        workload-status:
          current: unknown
          since: 29 Jul 2016 02:03:33Z
        agent-status:
          current: executing
          message: running db-relation-changed hook
          since: 29 Jul 2016 02:06:47Z
          version: 1.25.6
        agent-state: started
        agent-version: 1.25.6
        machine: "1"
        open-ports:
        - 80/tcp
        public-address: 10.197.194.164
```

# Juju frequently used commands
```
juju bootstrap -v
juju status
juju destory-environment
```

# Juju backup & recovery



# Reference
- https://jujucharms.com/docs/1.25/getting-started
- https://jujucharms.com/docs/1.25/config-aws
- https://jujucharms.com/docs/1.25/juju-backups
