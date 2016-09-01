# Redis HA Cluster를 위한 Keepalived 설정 사례

## node1
- /etc/keepalived/keepalived.conf
```
vrrp_script redis_check {
    script "killall -0 redis-server"
    interval 2
    fall 2       # require 2 failures for KO
    rise 2       # require 2 successes for OK
}

vrrp_instance VI_1 {
    state MASTER
    priority 200
    interface eth0
    virtual_router_id 11
    authentication {
        auth_type PASS
        auth_pass YourSecretPassword
    }
    virtual_ipaddress {
        10.0.0.11/16 brd 10.0.255.255 dev eth0
    }

    track_script {
        redis_check
    }
    notify_master "/etc/keepalived/notify.sh MASTER"
    notify_backup "/etc/keepalived/notify.sh BACKUP"
    notify_fault "/etc/keepalived/notify.sh FAULT"
}

```
-/etc/keepalived/notify.sh
  - perl 을 이용한 config 변경은 optional 
  - perl 설정 시 known problem: master(node1) redis stop/start 시 slave(node2) 가 잠시 master에서 slave로 변경. 이 때 slave config 에 slaveof 옵션이 깨짐 
```
#!/bin/bash

ENDSTATE=$1

PEER_HOST=10.0.3.11
PEER_PORT=6379

case $ENDSTATE in
    "MASTER") # Perform action for transition to MASTER state
              echo "***** keepalived transit to MASTER state" | logger -t keepalived-state-checker
              /usr/bin/redis-cli slaveof no one
              perl -pi -e 's/^slaveof.*/slaveof no one/' /etc/redis/redis.conf
              exit 0
              ;;
    "BACKUP") # Perform action for transition to BACKUP state
              echo "***** keepalived transit to BACKUP state" | logger -t keepalived-state-checker
              /usr/bin/redis-cli slaveof $PEER_HOST $PEER_PORT
              perl -pi -e 's/^slaveof.*/slaveof $PEER_HOST $PEER_PORT/' /etc/redis/redis.conf
              exit 0
              ;;
    "FAULT")  # Perform action for transition to FAULT state
              echo "***** keepalived transit to FAULT state" | logger -t keepalived-state-checker
              /usr/bin/redis-cli slaveof $PEER_HOST $PEER_PORT
              perl -pi -e 's/^slaveof.*/slaveof $PEER_HOST $PEER_PORT/' /etc/redis/redis.conf
              exit 0
              ;;
    *)        echo "***** Unknown state ${ENDSTATE} for VRRP" | logger -t keepalived-state-checker
              exit 1
              ;;
esac
```
- /etc/redis/redis.conf
```
tcp-keepalive 60   
# bind 127.0.0.1
# requirepass your_redis_master_password
# maxmemory-policy noeviction
appendonly yes
appendfilename appendonly.aof
```
## node2
- /etc/keepalived/keepalived.conf
```
vrrp_script redis_check {
    script "killall -0 redis-server"
    interval 2
    fall 2       # require 2 failures for KO
    rise 2       # require 2 successes for OK
}

vrrp_instance VI_1 {
    state MASTER
    priority 100
    interface eth0
    virtual_router_id 11
    authentication {
        auth_type PASS
        auth_pass YourSecretPassword
    }
    virtual_ipaddress {
        10.0.0.11/16 brd 10.0.255.255 dev eth0
    }

    track_script {
        redis_check
    }
    notify_master "/etc/keepalived/notify.sh MASTER"
    notify_backup "/etc/keepalived/notify.sh BACKUP"
    notify_fault "/etc/keepalived/notify.sh FAULT"
}

```
- /etc/keepalived/notify.sh
```
#!/bin/bash

ENDSTATE=$1

PEER_HOST=10.0.1.11
PEER_PORT=6379

case $ENDSTATE in
    "MASTER") # Perform action for transition to MASTER state
              echo "***** keepalived transit to MASTER state" | logger -t keepalived-state-checker
              /usr/bin/redis-cli slaveof no one
              perl -pi -e 's/^slaveof.*/slaveof no one/' /etc/redis/redis.conf
              exit 0
              ;;
    "BACKUP") # Perform action for transition to BACKUP state
              echo "***** keepalived transit to BACKUP state" | logger -t keepalived-state-checker
              /usr/bin/redis-cli slaveof $PEER_HOST $PEER_PORT
              perl -pi -e 's/^slaveof.*/slaveof $PEER_HOST $PEER_PORT/' /etc/redis/redis.conf
              exit 0
              ;;
    "FAULT")  # Perform action for transition to FAULT state
              echo "***** keepalived transit to FAULT state" | logger -t keepalived-state-checker
              /usr/bin/redis-cli slaveof $PEER_HOST $PEER_PORT
              perl -pi -e 's/^slaveof.*/slaveof $PEER_HOST $PEER_PORT/' /etc/redis/redis.conf
              exit 0
              ;;
    *)        echo "***** Unknown state ${ENDSTATE} for VRRP" | logger -t keepalived-state-checker
              exit 1
              ;;
esac
```
- /etc/redis/redis.conf
```
# bind 127.0.0.1
# requirepass your_redis_master_password
slaveof your_redis_master_ip 6379
# masterauth your_redis_master_password
```

